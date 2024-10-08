{
  config,
  pkgs,
  flake,
  inputs,
  ...
}:

{
  age.secrets."mastodon-secret-key-base" = {
    file = "${flake.self}/secrets/mastodon-secret-key-base.age";
    mode = "400";
    owner = config.services.mastodon.user;
  };
  age.secrets."mastodon-otp-secret" = {
    file = "${flake.self}/secrets/mastodon-otp-secret.age";
    mode = "400";
    owner = config.services.mastodon.user;
  };
  age.secrets."mastodon-vapid-private-key" = {
    file = "${flake.self}/secrets/mastodon-vapid-private-key.age";
    mode = "400";
    owner = config.services.mastodon.user;
  };
  age.secrets."mastodon-vapid-public-key" = {
    file = "${flake.self}/secrets/mastodon-vapid-public-key.age";
    mode = "400";
    owner = config.services.mastodon.user;
  };
  age.secrets."mastodon-smtp-password" = {
    file = "${flake.self}/secrets/mastodon-smtp-password.age";
    mode = "400";
    owner = config.services.mastodon.user;
  };
  age.secrets."mastodon-extra-env-secrets" = {
    file = "${flake.self}/secrets/mastodon-extra-env-secrets.age";
    mode = "400";
    owner = config.services.mastodon.user;
  };

  # Nginx user needs access to mastodon unix sockets
  users.users.nginx.extraGroups = [ "mastodon" ];

  services.mastodon = {
    enable = true;
    # Different from WEB_DOMAIN in our case
    localDomain = "${config.pub-solar-os.networking.domain}";
    enableUnixSocket = true;
    # Number of processes used by the mastodon-streaming service
    # Recommended is the amount of your CPU cores minus one
    # On our current 8-Core system, let's start with 5 for now
    streamingProcesses = 5;
    # Processes used by the mastodon-web service
    webProcesses = 2;
    # Threads per process used by the mastodon-web service
    webThreads = 5;
    secretKeyBaseFile = "/run/agenix/mastodon-secret-key-base";
    otpSecretFile = "/run/agenix/mastodon-otp-secret";
    vapidPrivateKeyFile = "/run/agenix/mastodon-vapid-private-key";
    vapidPublicKeyFile = "/run/agenix/mastodon-vapid-public-key";
    smtp = {
      createLocally = false;
      host = "mail.pub.solar";
      port = 587;
      authenticate = true;
      user = "admins@pub.solar";
      passwordFile = "/run/agenix/mastodon-smtp-password";
      fromAddress = "mastodon-notifications@pub.solar";
    };
    # Defined in ./opensearch.nix
    elasticsearch.host = "127.0.0.1";
    mediaAutoRemove = {
      olderThanDays = 7;
    };
    extraEnvFiles = [ "/run/agenix/mastodon-extra-env-secrets" ];
    extraConfig = {
      WEB_DOMAIN = "mastodon.${config.pub-solar-os.networking.domain}";
      # S3 File storage (optional)
      # -----------------------
      S3_ENABLED = "true";
      S3_BUCKET = "pub-solar-mastodon";
      S3_REGION = "europe-west-1";
      S3_ENDPOINT = "https://gateway.tardigradeshare.io";
      S3_ALIAS_HOST = "files.${config.pub-solar-os.networking.domain}";
      # Translation (optional)
      # -----------------------
      DEEPL_PLAN = "free";
      # OpenID Connect
      # --------------
      OIDC_ENABLED = "true";
      OIDC_DISPLAY_NAME = "pub.solar ID";
      OIDC_ISSUER = "https://auth.${config.pub-solar-os.networking.domain}/realms/${config.pub-solar-os.auth.realm}";
      OIDC_DISCOVERY = "true";
      OIDC_SCOPE = "openid,profile,email";
      OIDC_UID_FIELD = "preferred_username";
      OIDC_REDIRECT_URI = "https://mastodon.${config.pub-solar-os.networking.domain}/auth/auth/openid_connect/callback";
      OIDC_SECURITY_ASSUME_EMAIL_IS_VERIFIED = "true";
      # only use OIDC for login / registration
      OMNIAUTH_ONLY = "true";
    };
  };

  services.restic.backups.mastodon-storagebox = {
    paths = [ "/tmp/mastodon-backup.sql" ];
    timerConfig = {
      OnCalendar = "*-*-* 04:00:00 Etc/UTC";
    };
    initialize = true;
    passwordFile = config.age.secrets."restic-repo-storagebox-nachtigall".path;
    repository = "sftp:u377325@u377325.your-storagebox.de:/backups";
    backupPrepareCommand = ''
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d mastodon > /tmp/mastodon-backup.sql
    '';
    backupCleanupCommand = ''
      rm /tmp/mastodon-backup.sql
    '';
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };
}
