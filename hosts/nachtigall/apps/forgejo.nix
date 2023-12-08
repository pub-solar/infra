{
  config,
  lib,
  pkgs,
  flake,
  ...
}: {
  age.secrets.forgejo-database-password = {
    file = "${flake.self}/secrets/forgejo-database-password.age";
    mode = "600";
    owner = "gitea";
  };

  age.secrets.forgejo-mailer-password = {
    file = "${flake.self}/secrets/forgejo-mailer-password.age";
    mode = "600";
    owner = "gitea";
  };

  services.nginx.virtualHosts."git.pub.solar" = {
    enableACME = true;
    forceSSL = true;

    locations."/user/login".extraConfig = ''
        return 302 /user/oauth2/keycloak;
    '';

    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      extraConfig = ''
        client_max_body_size 1G;
      '';
    };
  };

  services.gitea = {
    enable = true;
    package = pkgs.forgejo;
    appName = "pub.solar git server";
    database = {
      type = "postgres";
      passwordFile = config.age.secrets.forgejo-database-password.path;
    };
    stateDir = "/var/lib/forgejo";
    lfs.enable = true;
    mailerPasswordFile = config.age.secrets.forgejo-mailer-password.path;
    settings = {
      server = {
        ROOT_URL = "https://git.pub.solar";
        DOMAIN = "git.pub.solar";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
      };

      log.LEVEL = "Warn";

      mailer = {
        ENABLED = true;
        PROTOCOL = "smtps";
        SMTP_ADDR = "mail.greenbaum.zone";
        SMTP_PORT = 465;
        FROM = ''"pub.solar git server" <forgejo@pub.solar>'';
        USER = "admins@pub.solar";
      };

      "repository.signing" = {
        SIGNING_KEY = "default";
        MERGES = "always";
      };

      openid = {
        ENABLE_OPENID_SIGNIN = true;
        ENABLE_OPENID_SIGNUP = true;
      };

      service = {
        # uncomment after initial deployment, first user is admin user
        # required to setup SSO (oauth openid-connect, keycloak auth provider)
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
        ENABLE_NOTIFY_MAIL = true;
        DEFAULT_KEEP_EMAIL_PRIVATE = true;
      };

      session = {
        PROVIDER = "db";
        COOKIE_SECURE = lib.mkForce true;
      };

      # https://forgejo.org/docs/latest/admin/config-cheat-sheet/#webhook-webhook
      webhook = {
        ALLOWED_HOST_LIST = "loopback,external,*.pub.solar";
      };

      # See https://forgejo.org/docs/latest/admin/actions/
      actions = {
        ENABLED = true;
        # In an actions workflow, when uses: does not specify an absolute URL,
        # the value of DEFAULT_ACTIONS_URL is prepended to it.
        DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
      };
    };
  };

  # See: https://docs.gitea.io/en-us/signing/#installing-and-generating-a-gpg-key-for-gitea
  # Required for gitea server side gpg signatures
  # configured/setup manually in:
  # /var/lib/gitea/data/home/.gitconfig
  # /var/lib/gitea/data/home/.gnupg/
  # sudo su gitea
  # export GNUPGHOME=/var/lib/gitea/data/home/.gnupg
  # gpg --quick-gen-key 'pub.solar gitea <gitea@pub.solar>' ed25519
  # TODO: implement declarative GPG key generation and
  # gitea gitconfig
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };
  # Required to make gpg work without a graphical environment?
  # otherwise generating a new gpg key fails with this error:
  # gpg: agent_genkey failed: No pinentry
  # see: https://github.com/NixOS/nixpkgs/issues/97861#issuecomment-827951675
  environment.variables = {
    GPG_TTY = "$(tty)";
  };

  services.restic.backups.forgejo-droppie = {
    paths = [
      "/var/lib/forgejo"
      "/tmp/forgejo-backup.sql"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00 Etc/UTC";
      # droppie will be offline if nachtigall misses the timer
      Persistent = false;
    };
    initialize = true;
    passwordFile = config.age.secrets."restic-repo-droppie".path;
    repository = "sftp:yule@droppie.b12f.io:/media/internal/pub.solar";
    backupPrepareCommand = ''
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d gitea > /tmp/forgejo-backup.sql
    '';
    backupCleanupCommand = ''
      rm /tmp/forgejo-backup.sql
    '';
  };

  services.restic.backups.forgejo-storagebox = {
    paths = [
      "/var/lib/forgejo"
      "/tmp/forgejo-backup.sql"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 04:20:00 Etc/UTC";
    };
    initialize = true;
    passwordFile = config.age.secrets."restic-repo-storagebox".path;
    repository = "sftp:u377325@u377325.your-storagebox.de:/backups";
    backupPrepareCommand = ''
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d gitea > /tmp/forgejo-backup.sql
    '';
    backupCleanupCommand = ''
      rm /tmp/forgejo-backup.sql
    '';
  };
}
