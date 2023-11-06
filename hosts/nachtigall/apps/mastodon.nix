{ config, pkgs, flake, inputs, ... }:

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
    localDomain = "pub.solar";
    enableUnixSocket = true;
    # Processes used by the mastodon-streaming service. Defaults to the number
    # of CPU cores minus one
    # This is without affect until this comment is addressed
    # https://github.com/NixOS/nixpkgs/pull/251950#issuecomment-1732568492
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
      host = "mx2.greenbaum.cloud";
      port = 587;
      authenticate = true;
      user = "admins@pub.solar";
      passwordFile = "/run/agenix/mastodon-smtp-password";
      fromAddress = "mastodon-notifications@pub.solar";
    };
    extraEnvFiles = [
      "/run/agenix/mastodon-extra-env-secrets"
    ];
    extraConfig = {
      WEB_DOMAIN = "mastodon.pub.solar";
      # Defined in ./opensearch.nix
      ES_HOST = "127.0.0.1";
      # S3 File storage (optional)
      # -----------------------
      S3_ENABLED = "true";
      S3_BUCKET = "pub-solar-mastodon";
      S3_REGION = "europe-west-1";
      S3_ENDPOINT = "https://gateway.tardigradeshare.io";
      S3_ALIAS_HOST = "files.pub.solar";
      # Translation (optional)
      # -----------------------
      DEEPL_PLAN = "free";
      # OpenID Connect
      # --------------
      OIDC_ENABLED = "true";
      OIDC_DISPLAY_NAME = "pub.solar ID";
      OIDC_ISSUER = "https://auth.pub.solar/realms/pub.solar";
      OIDC_DISCOVERY = "true";
      OIDC_SCOPE = "openid,profile,email";
      OIDC_UID_FIELD = "preferred_username";
      OIDC_REDIRECT_URI = "https://mastodon.pub.solar/auth/auth/openid_connect/callback";
      OIDC_SECURITY_ASSUME_EMAIL_IS_VERIFIED = "true";
      # only use OIDC for login / registration
      OMNIAUTH_ONLY = "true";
    };
  };

  services.restic.backups.mastodon = {
    paths = [
      "/tmp/mastodon-backup.sql"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00 Etc/UTC";
      # droppie will be offline if nachtigall misses the timer
      Persistent = false;
    };
    initialize = true;
    passwordFile = config.age.secrets."restic-repo-droppie".path;
    repository = "yule@droppie.b12f.io:/media/internal/backups-pub-solar";
    backupPrepareCommand = ''
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d mastodon > /tmp/mastodon-backup.sql
    '';
    backupCleanupCommand = ''
      rm /tmp/mastodon-backup.sql
    '';
  };
}
