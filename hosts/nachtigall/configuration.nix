{
  flake,
  config,
  pkgs,
  ...
}:
{
  # Use GRUB2 as the boot loader.
  # We don't use systemd-boot because Hetzner uses BIOS legacy boot.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    mirroredBoots = [
      {
        devices = [ "/dev/disk/by-id/nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NF0R517371" ];
        path = "/boot1";
      }
      {
        devices = [ "/dev/disk/by-id/nvme-KXG60ZNV1T02_TOSHIBA_Z9NF704ZF9ZL" ];
        path = "/boot2";
      }
      {
        devices = [ "/dev/disk/by-id/nvme-SAMSUNG_MZVL21T0HDLU-00B07_S77WNF0XA01902" ];
        path = "/boot3";
      }
      {
        devices = [ "/dev/disk/by-id/nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NU0W623944" ];
        path = "/boot4";
      }
    ];
    copyKernels = true;
  };
  boot.supportedFilesystems = [ "zfs" ];

  boot.kernelParams = [
    "boot.shell_on_fail=1"
    "ip=138.201.80.102::138.201.80.65:255.255.255.192:nachtigall::off"
  ];

  boot.initrd.availableKernelModules = [ "igb" ];

  # https://nixos.wiki/wiki/ZFS#declarative_mounting_of_ZFS_datasets
  systemd.services.zfs-mount.enable = false;

  services.zfs.autoScrub = {
    enable = true;
    pools = [ "root_pool" ];
  };

  # Declarative SSH private key
  age.secrets."nachtigall-root-ssh-key" = {
    file = "${flake.self}/secrets/nachtigall-root-ssh-key.age";
    path = "/root/.ssh/id_ed25519";
    mode = "400";
    owner = "root";
  };

  # keycloak
  age.secrets.keycloak-database-password = {
    file = "${flake.self}/secrets/keycloak-database-password.age";
    mode = "600";
    #owner = "keycloak";
  };

  pub-solar-os.auth = {
    enable = true;
    database-password-file = config.age.secrets.keycloak-database-password.path;
  };

  # matrix-synapse
  age.secrets."matrix-synapse-signing-key" = {
    file = "${flake.self}/secrets/matrix-synapse-signing-key.age";
    mode = "400";
    owner = "matrix-synapse";
  };

  age.secrets."matrix-synapse-secret-config.yaml" = {
    file = "${flake.self}/secrets/matrix-synapse-secret-config.yaml.age";
    mode = "400";
    owner = "matrix-synapse";
  };

  age.secrets."matrix-authentication-service-secret-config.yml" = {
    file = "${flake.self}/secrets/matrix-authentication-service-secret-config.yml.age";
    mode = "400";
    owner = "matrix-authentication-service";
  };

  # matrix-appservice-irc
  age.secrets."matrix-appservice-irc-mediaproxy-signing-key" = {
    file = "${flake.self}/secrets/matrix-appservice-irc-mediaproxy-signing-key.jwk.age";
    mode = "400";
    owner = "matrix-appservice-irc";
  };

  age.secrets."matrix-draupnir-access-token" = {
    file = "${flake.self}/secrets/matrix-draupnir-access-token.age";
    mode = "400";
    owner = "root";
  };

  age.secrets."matrix-draupnir-http-antispam-authorization-file" = {
    file = "${flake.self}/secrets/staging-matrix-draupnir-http-antispam-authorization-file.age";
    mode = "440";
    owner = "root";
    group = "matrix-synapse";
  };

  pub-solar-os.matrix = {
    enable = true;
    appservice-irc.mediaproxy.signingKeyPath =
      config.age.secrets."matrix-appservice-irc-mediaproxy-signing-key".path;
    synapse = {
      signing_key_path = config.age.secrets."matrix-synapse-signing-key".path;
      extra-config-files = [
        config.age.secrets."matrix-synapse-secret-config.yaml".path

        # The registration file is automatically generated after starting the
        # appservice for the first time.
        # cp /var/lib/mautrix-telegram/telegram-registration.yaml \
        #   /var/lib/matrix-synapse/
        # chown matrix-synapse:matrix-synapse \
        #   /var/lib/matrix-synapse/telegram-registration.yaml
        "/var/lib/matrix-synapse/telegram-registration.yaml"
      ];
      app-service-config-files = [
        "/var/lib/matrix-synapse/telegram-registration.yaml"
        "/var/lib/matrix-appservice-irc/registration.yml"
        # "/matrix-appservice-slack-registration.yaml"
        # "/hookshot-registration.yml"
        # "/matrix-mautrix-signal-registration.yaml"
        # "/matrix-mautrix-telegram-registration.yaml"
      ];
    };
    matrix-authentication-service.extra-config-files = [
      config.age.secrets."matrix-authentication-service-secret-config.yml".path
    ];
    draupnir = {
      enable = true;
      homeserver-url = "http://127.0.200.10:8008";
      access-token-file = config.age.secrets."matrix-draupnir-access-token".path;
      http-antispam-authorization-file =
        config.age.secrets."matrix-draupnir-http-antispam-authorization-file".path;
    };
  };

  systemd.services.postgresql = {
    after = [ "var-lib-postgresql.mount" ];
    requisite = [ "var-lib-postgresql.mount" ];
  };

  age.secrets."keycloak-admin-cli-client-secret" = {
    file = "${flake.self}/secrets/keycloak-admin-cli-client-secret.age";
  };

  age.secrets."matrix-admin-access-token" = {
    file = "${flake.self}/secrets/matrix-admin-access-token.age";
  };

  environment.systemPackages = [
    pkgs.delete-pubsolar-id
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.05"; # Did you read the comment?
}
