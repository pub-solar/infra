{ config
, lib
, pkgs
, flake
, ...
}: {
  age.secrets.drone-secrets = {
    file = "${flake.self}/secrets/drone-secrets.age";
    mode = "600";
    owner = "drone";
  };
  age.secrets.drone-db-secrets = {
    file = "${flake.self}/secrets/drone-db-secrets.age";
    mode = "600";
    owner = "drone";
  };

  users.users.drone = {
    description = "Drone Service";
    home = "/var/lib/drone";
    useDefaultShell = true;
    uid = 994;
    group = "drone";
    isSystemUser = true;
  };

  users.groups.drone = { };

  systemd.tmpfiles.rules = [
    "d '/var/lib/drone-db' 0750 drone drone - -"
  ];

  systemd.services."docker-network-drone" =
    let
      docker = config.virtualisation.oci-containers.backend;
      dockerBin = "${pkgs.${docker}}/bin/${docker}";
    in
    {
      serviceConfig.Type = "oneshot";
      before = [ "docker-drone-server.service" ];
      script = ''
        ${dockerBin} network inspect drone-net >/dev/null 2>&1 || ${dockerBin} network create drone-net --subnet 172.20.0.0/24
      '';
    };

  virtualisation = {
    docker = {
      enable = true; # sadly podman is not supported rightnow
      extraOptions = ''
        --data-root /data/docker
      '';
    };

    oci-containers = {
      backend = "docker";
      containers."drone-db" = {
        image = "postgres:14";
        autoStart = true;
        user = "994";
        volumes = [
          "/var/lib/drone-db:/var/lib/postgresql/data"
        ];
        extraOptions = [
          "--network=drone-net"
        ];
        environmentFiles = [
          config.age.secrets.drone-db-secrets.path
        ];
      };
      containers."drone-server" = {
        image = "drone/drone:2";
        autoStart = true;
        user = "994";
        ports = [
          "4000:80"
        ];
        dependsOn = [ "drone-db" ];
        extraOptions = [
          "--network=drone-net"
          "--pull=always"
        ];
        environment = {
          DRONE_GITEA_SERVER = "https://git.pub.solar";
          DRONE_SERVER_HOST = "ci.pub.solar";
          DRONE_SERVER_PROTO = "https";
          DRONE_DATABASE_DRIVER = "postgres";
        };
        environmentFiles = [
          config.age.secrets.drone-secrets.path
        ];
      };
      containers."drone-docker-runner" = {
        image = "drone/drone-runner-docker:1";
        autoStart = true;
        # needs to run as root
        #user = "994";
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        dependsOn = [ "drone-db" ];
        extraOptions = [
          "--network=drone-net"
          "--pull=always"
        ];
        environment = {
          DRONE_RPC_HOST = "ci.pub.solar";
          DRONE_RPC_PROTO = "https";
          DRONE_RUNNER_CAPACITY = "2";
          DRONE_RUNNER_NAME = "flora-6-docker-runner";
        };
        environmentFiles = [
          config.age.secrets.drone-secrets.path
        ];
      };
    };
  };
}
