{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
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

  age.secrets.forgejo-ssh-private-key = {
    file = "${flake.self}/secrets/forgejo-ssh-private-key.age";
    mode = "600";
    owner = "gitea";
    path = "/etc/forgejo/ssh/id_forgejo";
  };

  environment.etc."forgejo/ssh/id_forgejo.pub" = {
    text = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkPjvF2tZ2lZtkXed6lBvaPUpsNrI5kHlCNEf4LyFtgFXHoUL8UD3Bz9Fn1S+SDkdBMw/SumjvUf7TEGqQqzmFbG7+nWdWg2L00VdN8Kp8W+kKPBByJrzjDUIGhIMt7obaZnlSAVO5Cdqc1Q6bA9POLjSHIBxSD3QUs2pjUCkciNcEtL93easuXnlMwoYa217n5sA8n+BZmOJAcmA/UxYvKsqYlpJxa44m8JgMTy+5L08i/zkx9/FwniOcKcLedxmjZfV8raitDy34LslT2nBNG4I+em7qhKhSScn/cfyPvARiK71pk/rTx9mxBEjcGAkp3+hiA3Nyms0h/qTUh8yGyhbOn8hiro34HEKswXDN1HRfseyyZ4TqOoIC07F53x4OliYA0B+QbvwOemTX2XAWHfU4xEYrIhR46o3Eu5ooOM9HZLLYzIzKjsj/rpuKalFZ+9IeT/PJ/DrbgOEBlJGTu4XucEYXSiIvWB7G9WXij7TXKYbsRAFho9jw+9UZWklFAh9dcUKlX9YxafxOrw9DhJK620hblHLY9wPPFCbZVXDGfqdtn+ncRReMAw6N3VYqxMgnxd+OC52SMsSUi9VaL26i2UvEBwNYuim8GDnVabu/ciQLHMgifBONuF9sKD58ee5nnKgtYLDy9zU86aHBU78Ijew+WhYitO7qejMHMQ==";
    mode = "600";
    user = "gitea";
  };

  services.nginx.virtualHosts."git.${config.pub-solar-os.networking.domain}" = {
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

  users.users.gitea = {
    home = "/var/lib/forgejo";
    useDefaultShell = true;
    group = "gitea";
    isSystemUser = true;
  };

  users.groups.gitea = { };

  # Expose SSH port only for forgejo SSH
  networking.firewall.interfaces.enp35s0.allowedTCPPorts = [ 2223 ];
  networking.firewall.extraCommands = ''
    iptables -t nat -i enp35s0 -I PREROUTING -p tcp --dport 22 -j REDIRECT --to-ports 2223
    ip6tables -t nat -i enp35s0 -I PREROUTING -p tcp --dport 22 -j REDIRECT --to-ports 2223
  '';

  services.forgejo = {
    enable = true;
    user = "gitea";
    group = "gitea";
    database = {
      type = "postgres";
      passwordFile = config.age.secrets.forgejo-database-password.path;
      name = "gitea";
      user = "gitea";
    };
    stateDir = "/var/lib/forgejo";
    lfs.enable = true;
    mailerPasswordFile = config.age.secrets.forgejo-mailer-password.path;
    settings = {
      DEFAULT.APP_NAME = "pub.solar git server";

      server = {
        ROOT_URL = "https://git.${config.pub-solar-os.networking.domain}";
        DOMAIN = "git.${config.pub-solar-os.networking.domain}";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        START_SSH_SERVER = true;
        SSH_LISTEN_PORT = 2223;
        SSH_SERVER_HOST_KEYS = "${config.age.secrets."forgejo-ssh-private-key".path}";
      };

      log.LEVEL = "Warn";

      mailer = {
        ENABLED = true;
        PROTOCOL = "smtps";
        SMTP_ADDR = "mail.pub.solar";
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
        ALLOWED_HOST_LIST = "loopback,external,*.${config.pub-solar-os.networking.domain}";
      };

      # See https://forgejo.org/docs/latest/admin/actions/
      actions = {
        ENABLED = true;
        # In an actions workflow, when uses: does not specify an absolute URL,
        # the value of DEFAULT_ACTIONS_URL is prepended to it.
        DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
      };

      # https://forgejo.org/docs/next/admin/recommendations/#securitylogin_remember_days
      security = {
        LOGIN_REMEMBER_DAYS = 365;
      };

      # https://forgejo.org/docs/next/admin/config-cheat-sheet/#indexer-indexer
      indexer = {
        REPO_INDEXER_ENABLED = true;
        REPO_INDEXER_PATH = "indexers/repos.bleve";
        MAX_FILE_SIZE = 1048576;
        REPO_INDEXER_EXCLUDE = "resources/bin/**";
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
    pinentryPackage = pkgs.pinentry-curses;
  };
  # Required to make gpg work without a graphical environment?
  # otherwise generating a new gpg key fails with this error:
  # gpg: agent_genkey failed: No pinentry
  # see: https://github.com/NixOS/nixpkgs/issues/97861#issuecomment-827951675
  environment.variables = {
    GPG_TTY = "$(tty)";
  };

  services.restic.backups.forgejo-storagebox = {
    paths = [
      "/var/lib/forgejo"
      "/tmp/forgejo-backup.sql"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 00:00:00 Etc/UTC";
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
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };
}
