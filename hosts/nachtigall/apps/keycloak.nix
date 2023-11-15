{
  flake,
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.keycloak-database-password = {
    file = "${flake.self}/secrets/keycloak-database-password.age";
    mode = "600";
    #owner = "keycloak";
  };

  services.nginx.virtualHosts."auth.pub.solar" = {
    enableACME = true;
    forceSSL = true;

    locations = {
      "= /" = {
        extraConfig = ''
          return 302 /realms/pub.solar/account;
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
    database.passwordFile = config.age.secrets.keycloak-database-password.path;
    settings = {
      hostname = "auth.pub.solar";
      http-host = "127.0.0.1";
      http-port = 8080;
      proxy = "edge";
      features = "declarative-user-profile";
    };
    themes = {
      "pub.solar" = flake.inputs.keycloak-theme-pub-solar.legacyPackages.${pkgs.system}.keycloak-theme-pub-solar;
    };
  };

  services.restic.backups.keycloak = {
    paths = [
      "/tmp/keycloak-backup.sql"
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
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d keycloak > /tmp/keycloak-backup.sql
    '';
    backupCleanupCommand = ''
      rm /tmp/keycloak-backup.sql
    '';
  };
}
