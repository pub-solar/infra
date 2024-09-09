{
  config,
  lib,
  pkgs,
  self,
  flake,
  ...
}:
let
  configPy = pkgs.writeText "obs-portal-config.py" ''
    DEBUG = False
    VERBOSE = DEBUG
    AUTO_RESTART = DEBUG
    LEAN_MODE = False
    FRONTEND_URL = None
    FRONTEND_HTTPS = True
    FRONTEND_DIR = "../frontend/build/"
    FRONTEND_CONFIG = {
        "imprintUrl": "${config.pub-solar-os.imprintUrl}",
        "privacyPolicyUrl": "${config.pub-solar-os.privacyPolicyUrl}",
        "mapHome": {"zoom": 12, "latitude": 50.93, "longitude": 6.97},
        "banner": {
            "text": "This is an installation serving the Cologne/Bonn region run for Team OBSKöln by pub.solar n.e.V.",
            "style": "info"
        },
    }
    TILES_FILE = None
    ADDITIONAL_CORS_ORIGINS = None
  '';

  env = {
    OBS_KEYCLOAK_URI = "auth.${config.pub-solar-os.networking.domain}";
    OBS_PORTAL_URI = "obs-portal.${config.pub-solar-os.networking.domain}";

    OBS_POSTGRES_MAX_OVERFLOW = "20";
    OBS_POSTGRES_POOL_SIZE = "40";

    OBS_HOST = "0.0.0.0";
    OBS_PORT = "3000";
    OBS_KEYCLOAK_URL = "https://auth.${config.pub-solar-os.networking.domain}/realms/${config.pub-solar-os.auth.realm}/";
    OBS_KEYCLOAK_CLIENT_ID = "openbikesensor-portal";
    OBS_DEDICATED_WORKER = "True";
    OBS_DATA_DIR = "/data";
    OBS_PROXIES_COUNT = "1";
  };
in
{
  age.secrets.obs-portal-env = {
    file = "${flake.self}/secrets/obs-portal-env.age";
    mode = "600";
  };

  age.secrets.obs-portal-database-env = {
    file = "${flake.self}/secrets/obs-portal-database-env.age";
    mode = "600";
  };

  systemd.services."docker-network-obs-portal" =
    let
      docker = config.virtualisation.oci-containers.backend;
      dockerBin = "${pkgs.${docker}}/bin/${docker}";
    in
    {
      serviceConfig.Type = "oneshot";
      before = [
        "docker-obs-portal.service"
        "docker-obs-portal-db.service"
        "docker-obs-portal-worker.service"
      ];
      requiredBy = [
        "docker-obs-portal.service"
        "docker-obs-portal-db.service"
        "docker-obs-portal-worker.service"
      ];
      script = ''
        ${dockerBin} network inspect obs-portal-net >/dev/null 2>&1 || ${dockerBin} network create obs-portal-net --subnet 172.20.0.0/24
      '';
    };

  services.nginx.virtualHosts."obs-portal.${config.pub-solar-os.networking.domain}" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyWebsockets = true;
      extraConfig = ''
        proxy_pass http://127.0.0.1:3001;
        proxy_set_header Host $host;
      '';
    };
  };

  virtualisation = {
    oci-containers = {
      backend = "docker";

      containers."obs-portal" = {
        image = "git.pub.solar/pub-solar/obs-portal:latest";
        autoStart = true;
        ports = [ "127.0.0.1:3001:${env.OBS_PORT}" ];
        dependsOn = [
          "obs-portal-db"
          "obs-portal-worker"
        ];

        environment = env;
        environmentFiles = [ config.age.secrets.obs-portal-env.path ];

        volumes = [
          "${configPy}:/opt/obs/api/config.py"
          "/var/lib/obs-portal${env.OBS_DATA_DIR}:${env.OBS_DATA_DIR}"
          "/var/lib/obs-portal/pbf/:/pbf"
        ];

        extraOptions = [ "--network=obs-portal-net" ];
      };

      containers."obs-portal-worker" = {
        image = "git.pub.solar/pub-solar/obs-portal:latest";
        autoStart = true;

        cmd = [
          "python"
          "tools/process_track.py"
        ];

        environment = env;
        environmentFiles = [ config.age.secrets.obs-portal-env.path ];

        volumes = [
          "${configPy}:/opt/obs/api/config.py"
          "/var/lib/obs-portal${env.OBS_DATA_DIR}:${env.OBS_DATA_DIR}"
        ];

        extraOptions = [ "--network=obs-portal-net" ];
      };

      containers."obs-portal-db" = {
        image = "openmaptiles/postgis:7.0";
        autoStart = true;

        environmentFiles = [ config.age.secrets.obs-portal-database-env.path ];

        volumes = [ "/var/lib/postgres-obs-portal/data:/var/lib/postgresql/data" ];

        extraOptions = [ "--network=obs-portal-net" ];
      };
    };
  };

  pub-solar-os.backups.restic.obs-portal = {
    paths = [
      "/var/lib/obs-portal/data"
      "/tmp/obs-portal-backup.sql"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 01:30:00 Etc/UTC";
    };
    initialize = true;
    backupPrepareCommand = ''
      ${pkgs.docker}/bin/docker exec -i --user postgres obs-portal-db pg_dump obs > /tmp/obs-portal-backup.sql
    '';
    backupCleanupCommand = ''
      rm /tmp/obs-portal-backup.sql
    '';
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };
}
