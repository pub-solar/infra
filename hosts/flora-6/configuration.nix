{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
let
  psCfg = config.pub-solar;
in
{
  config = {
    # Override nix.conf for more agressive garbage collection
    nix.extraOptions = lib.mkForce ''
      experimental-features = flakes nix-command
      min-free = 536870912
      keep-outputs = false
      keep-derivations = false
      fallback = true
    '';

    # # #
    # # # Triton host specific options
    # # # DO NOT ALTER below this line, changes might render system unbootable
    # # #

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Force getting the hostname from cloud-init
    networking.hostName = lib.mkDefault "";

    # We use cloud-init to configure networking, this option should fix
    # systemd-networkd-wait-online timeouts
    #systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
    systemd.network.wait-online.ignoredInterfaces = [
      "docker0"
      "wg-ssh"
    ];

    # List services that you want to enable:
    services.cloud-init.enable = true;
    services.cloud-init.ext4.enable = true;
    services.cloud-init.network.enable = true;
    # use the default NixOS cloud-init config, but add some SmartOS customization to it
    environment.etc."cloud/cloud.cfg.d/90_smartos.cfg".text = ''
      datasource_list: [ SmartOS ]

      # Do not create the centos/ubuntu/debian user
      users: [ ]

      # mount second disk with label ephemeral0, gets formated by cloud-init
      # this will fail to get added to /etc/fstab as it's read-only, but should
      # mount at boot anyway
      mounts:
      - [ vdb, /data, auto, "defaults,nofail" ]
    '';

    # We manage the firewall with nix, too
    # altough triton can also manage firewall rules via the triton fwrule subcommand
    networking.firewall.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.05"; # Did you read the comment?
  };
}
