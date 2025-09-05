{
  flake,
  config,
  pkgs,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  boot.supportedFilesystems = [ "zfs" ];

  boot.kernelParams = [
    "boot.shell_on_fail=1"
    "ip=dhcp"
  ];

  boot.initrd.availableKernelModules = [ "igb" ];

  # https://wiki.nixos.org/wiki/ZFS#ZFS_conflicting_with_systemd
  systemd.services.zfs-mount.enable = false;

  services.zfs.autoScrub = {
    enable = true;
    pools = [ "root_pool" ];
  };

  # Declarative SSH private key
  age.secrets."metronom-root-ssh-key" = {
    file = "${flake.self}/secrets/metronom-root-ssh-key.age";
    path = "/root/.ssh/id_ed25519";
    mode = "400";
    owner = "root";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.11"; # Did you read the comment?
}
