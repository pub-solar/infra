{ config, pkgs, ... }:
{
  # Use GRUB2 as the boot loader.
  # We don't use systemd-boot because Hetzner uses BIOS legacy boot.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    mirroredBoots = [
      {
        devices = [
          "/dev/disk/by-id/nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NF0R517371"
        ];
        path = "/boot1";
      }
      {
        devices = [
          "/dev/disk/by-id/nvme-KXG60ZNV1T02_TOSHIBA_Z9NF704ZF9ZL"
        ];
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

  # Set your time zone.
  time.timeZone = "Etc/UTC";

  environment = {
    # just a couple of packages to make our lives easier
    systemPackages = with pkgs; [ vim ];
  };

  users.users.hakkonaut = {
    description = "CI and automation user";
    home = "/home/hakkonaut";
    createHome = true;
    useDefaultShell = true;
    uid = 998;
    group = "hakkonaut";
    isSystemUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGP5MvCwNRtCcP1pSDrn0XZTNlpOqYnjHDm9/OI4hECW hakkonaut@flora-6"
    ];
  };

  # https://nixos.wiki/wiki/ZFS#declarative_mounting_of_ZFS_datasets
  systemd.services.zfs-mount.enable = false;

  users.groups.hakkonaut = {};

  users.users.root.initialHashedPassword = "$y$j9T$bIN6GjQkmPMllOcQsq52K0$q0Z5B5.KW/uxXK9fItB8H6HO79RYAcI/ZZdB0Djke32";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.05"; # Did you read the comment?
}
