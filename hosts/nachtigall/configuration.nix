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
  age.secrets."nachtigall-matrix-synapse-signing-key" = {
    file = "${flake.self}/secrets/nachtigall-matrix-synapse-signing-key.age";
    path = "/run/agenix/matrix-synapse-signing-key";
    mode = "400";
    owner = "matrix-synapse";
  };

  age.secrets."nachtigall-matrix-synapse-secret-config.yaml" = {
    file = "${flake.self}/secrets/nachtigall-matrix-synapse-secret-config.yaml.age";
    path = "/run/agenix/matrix-synapse-secret-config.yaml";
    mode = "400";
    owner = "matrix-synapse";
  };

  age.secrets."nachtigall-matrix-synapse-sliding-sync-secret" = {
    file = "${flake.self}/secrets/nachtigall-matrix-synapse-sliding-sync-secret.age";
    path = "/run/agenix/matrix-synapse-sliding-sync-secret";
    mode = "400";
    owner = "matrix-synapse";
  };


  pub-solar-os.matrix-synapse = {
    enable = true;
    sliding-sync.enable = true;
    signing_key_path = config.age.secrets."nachtigall-matrix-synapse-signing-key".path;
    extra-config-files = [
      config.age.secrets."nachtigall-matrix-synapse-secret-config.yaml".path

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

  systemd.services.postgresql = {
    after = [ "var-lib-postgresql.mount" ];
    requisite = [ "var-lib-postgresql.mount" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.05"; # Did you read the comment?
}
