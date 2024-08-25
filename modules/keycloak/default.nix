{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
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
    services.nginx.virtualHosts."auth.${config.pub-solar-os.networking.domain}" = {
      enableACME = true;
      forceSSL = true;

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

    nixpkgs.config = lib.mkDefault { permittedInsecurePackages = [ "keycloak-23.0.6" ]; };

    # keycloak
    services.keycloak = {
      enable = true;
      database.passwordFile = config.pub-solar-os.auth.database-password-file;
      settings = {
        hostname = "auth.${config.pub-solar-os.networking.domain}";
        http-host = "127.0.0.1";
        http-port = 8080;
        proxy = "edge";
      };
      themes = {
        "pub.solar" =
          flake.inputs.keycloak-theme-pub-solar.legacyPackages.${pkgs.system}.keycloak-theme-pub-solar;
      };
    };

    pub-solar-os.backups.backups.keycloak = {
      paths = [ "/tmp/keycloak-backup.sql" ];
      timerConfig = {
        OnCalendar = "*-*-* 03:00:00 Etc/UTC";
      };
      initialize = true;
      backupPrepareCommand = ''
        ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d keycloak > /tmp/keycloak-backup.sql
      '';
      backupCleanupCommand = ''
        rm /tmp/keycloak-backup.sql
      '';
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 3"
      ];
    };
  };
}
