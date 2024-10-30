{
  flake,
  config,
  pkgs,
  ...
}:
{
  # Use GRUB2 as the boot loader.
  boot.loader.grub = {
    enable = true;
    devices = [ "/dev/vda" ];
  };

  pub-solar-os.networking.domain = "test.pub.solar";

  systemd.tmpfiles.rules = [ "f /tmp/dbf 1777 root root 10d password" ];

  # keycloak
  pub-solar-os.auth = {
    enable = true;
    database-password-file = "/tmp/dbf";
  };
  services.keycloak.database.createLocally = true;

  # matrix-synapse
  # test.pub.solar /.well-known is required for federation
  services.nginx.virtualHosts."${config.pub-solar-os.networking.domain}" = {
    default = true;
    enableACME = true;
    forceSSL = true;
  };

  age.secrets."staging-matrix-synapse-secret-config.yaml" = {
    file = "${flake.self}/secrets/staging-matrix-synapse-secret-config.yaml.age";
    mode = "400";
    owner = "matrix-synapse";
  };

  age.secrets."staging-matrix-authentication-service-secret-config.yml" = {
    file = "${flake.self}/secrets/staging-matrix-authentication-service-secret-config.yml.age";
    mode = "400";
    owner = "matrix-authentication-service";
  };

  pub-solar-os.matrix = {
    enable = true;
    synapse = {
      extra-config-files = [
        config.age.secrets."staging-matrix-synapse-secret-config.yaml".path

        # The registration file is automatically generated after starting the
        # appservice for the first time.
        # cp /var/lib/mautrix-telegram/telegram-registration.yaml \
        #   /var/lib/matrix-synapse/
        # chown matrix-synapse:matrix-synapse \
        #   /var/lib/matrix-synapse/telegram-registration.yaml
        #"/var/lib/matrix-synapse/telegram-registration.yaml"
      ];
      app-service-config-files = [
        "/var/lib/matrix-appservice-irc/registration.yml"
        #"/var/lib/matrix-synapse/telegram-registration.yaml"
      ];
    };
    matrix-authentication-service.extra-config-files = [
      config.age.secrets."staging-matrix-authentication-service-secret-config.yml".path
    ];
  };

  services.openssh.openFirewall = true;

  system.stateVersion = "24.05";
}
