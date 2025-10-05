{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  vHostDomain = "auth.${config.pub-solar-os.networking.domain}";
in
{
  options.pub-solar-os.auth = with lib; {
    enable = mkEnableOption "Enable keycloak to run on the node";

    realm = mkOption {
      description = "Name of the realm";
      type = types.str;
      default = config.pub-solar-os.networking.domain;
    };

    database-password-file = mkOption {
      description = "Database password file path";
      type = types.str;
    };
  };

  config = lib.mkIf config.pub-solar-os.auth.enable {
    services.nginx.virtualHosts.${vHostDomain} = {
      enableACME = true;
      forceSSL = true;

      extraConfig = ''
        access_log /var/log/nginx/${vHostDomain}-access.log combined_host;
        error_log /var/log/nginx/${vHostDomain}-error.log;
      '';

      locations = {
        "= /" = {
          extraConfig = ''
            return 302 /realms/${config.pub-solar-os.auth.realm}/account;
          '';
        };

        "/" = {
          extraConfig = ''
            proxy_pass http://127.0.0.1:8080;
            proxy_buffer_size 8k;
          '';
        };
      };
    };

    # keycloak
    services.keycloak = {
      enable = true;
      database.passwordFile = config.pub-solar-os.auth.database-password-file;
      settings = {
        hostname = "auth.${config.pub-solar-os.networking.domain}";
        http-host = "127.0.0.1";
        http-port = 8080;
        proxy-headers = "xforwarded";
        http-enabled = true;
      };
      themes = {
        "pub.solar" =
          flake.inputs.keycloak-theme-pub-solar.legacyPackages.${pkgs.system}.keycloak-theme-pub-solar;
      };
      plugins = [ flake.inputs.keycloak-event-listener.packages.${pkgs.system}.keycloak-event-listener ];
    };

    pub-solar-os.backups = {
      resources.keycloak-db.resourceCreateCommand = ''
        ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d keycloak | ${pkgs.zstd}/bin/zstd --force --quiet -o /tmp/keycloak-backup.sql
      '';
      restic.keycloak = {
        resources = [ "keycloak-db" ];
        paths = [ "/tmp/keycloak-backup.sql" ];
        timerConfig = {
          OnCalendar = "*-*-* 03:00:00 Etc/UTC";
        };
        initialize = true;
      };
    };
  };
}
