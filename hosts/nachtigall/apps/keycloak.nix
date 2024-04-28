{ flake
, config
, lib
, pkgs
, ...
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
		plugins = [
			flake.inputs.keycloak-event-listener.packages.${pkgs.system}.keycloak-event-listener
		];
  };

  services.restic.backups.keycloak-droppie = {
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
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };

  services.restic.backups.keycloak-storagebox = {
    paths = [
      "/tmp/keycloak-backup.sql"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 04:10:00 Etc/UTC";
    };
    initialize = true;
    passwordFile = config.age.secrets."restic-repo-storagebox".path;
    repository = "sftp:u377325@u377325.your-storagebox.de:/backups";
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
}
