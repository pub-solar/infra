{
  config,
  lib,
  flake,
  pkgs,
  ...
}:

let
  vHostDomain = "photos.${config.pub-solar-os.networking.domain}";
  cfg = config.pub-solar-os.immich;
in
{
  imports = [
    "${flake.inputs.unstable}/nixos/modules/services/web-apps/immich.nix"
  ];

  disabledModules = [
    "services/web-apps/immich.nix"
  ];

  options.pub-solar-os.immich = {
    oauthIssuerUrl = lib.mkOption {
      description = -"URL to the .well-known/openid-configuration";
      type = lib.types.str;
    };
    oauthClientId = lib.mkOption {
      description = "OAuth client id";
      type = lib.types.str;
    };
    oauthClientSecretFile = lib.mkOption {
      description = "Path to OAuth client secret file";
      type = lib.types.path;
    };
  };
  config = {
    services.immich = {
      enable = true;
      environment = {
        IMMICH_TELEMETRY_INCLUDE = "all";
        IMMICH_API_METRICS_PORT = "9206";
        IMMICH_MICROSERVICES_METRICS_PORT = "9207";
        # IMMICH_LOG_LEVEL = "warn";
      };
      settings = {
        oauth = {
          enabled = true;

          issuerUrl = cfg.oauthIssuerUrl;
          clientId = cfg.oauthClientId;
          clientSecret._secret = cfg.oauthClientSecretFile;

          autoLaunch = true;
          buttonText = "Login with pub.solar ID";

          autoRegister = true;
          defaultStorageQuota = 1; # GB
        };
      };
    };

    services.nginx.virtualHosts."${vHostDomain}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.immich.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };

    services.restic.backups.immich-storagebox = {
      paths = [
        "/var/lib/immich"
        "/tmp/immich-backup.sql"
      ];
      timerConfig = {
        OnCalendar = "*-*-* 06:00:00 Etc/UTC";
      };
      initialize = true;
      passwordFile = config.age.secrets."restic-repo-storagebox-nachtigall".path;
      repository = "sftp:u377325@u377325.your-storagebox.de:/backups";
      backupPrepareCommand = ''
        ${pkgs.sudo}/bin/sudo -u postgres ${config.services.postgresql.package}/bin/pg_dump -d immich | ${pkgs.zstd}/bin/zstd --force --quiet -o /tmp/immich-backup.sql
      '';
      backupCleanupCommand = ''
        rm /tmp/immich-backup.sql
      '';
    };
  };
}
