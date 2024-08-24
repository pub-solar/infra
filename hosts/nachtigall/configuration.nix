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

  age.secrets.keycloak-database-password = {
    file = "${flake.self}/secrets/keycloak-database-password.age";
    mode = "600";
    #owner = "keycloak";
  };

  pub-solar-os.auth = {
    enable = true;
    database-password-file = config.age.secrets.keycloak-database-password.path;
  };

  pub-solar-os.backups.stores.storagebox = {
    passwordFile = config.age.secrets."restic-repo-storagebox".path;
    repository = "sftp:u377325@u377325.your-storagebox.de:/backups";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.05"; # Did you read the comment?
}
