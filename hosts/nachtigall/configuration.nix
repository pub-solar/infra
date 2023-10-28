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

  networking.hostName = "nachtigall";
  networking.domain = "pub.solar";
  networking.hostId = "00000001";

  # enable flakes by default
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Set your time zone.
  time.timeZone = "Etc/UTC";

  environment = {
    # just a couple of packages to make our lives easier
    systemPackages = with pkgs; [ vim ];
  };

  # Network (Hetzner uses static IP assignments, and we don't use DHCP here)
  networking.useDHCP = false;
  networking.interfaces."enp35s0".ipv4.addresses = [
    {
      address = "138.201.80.102";
      prefixLength = 26;
    }
  ];
  networking.interfaces."enp35s0".ipv6.addresses = [
    {
      address = "2a01:4f8:172:1c25::1";
      prefixLength = 64;
    }
  ];
  networking.defaultGateway = "138.201.80.65";
  networking.defaultGateway6 = { address = "fe80::1"; interface = "enp35s0"; };

  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net 193.110.81.0#dns0.eu 185.253.5.0#dns0.eu 2a0f:fc80::#dns0.eu 2a0f:fc81::#dns0.eu
      FallbackDNS=5.1.66.255#dot.ffmuc.net 185.150.99.255#dot.ffmuc.net 2001:678:e68:f000::#dot.ffmuc.net 2001:678:ed0:f000::#dot.ffmuc.net
      Domains=~.
      DNSOverTLS=yes
    '';
  };

  users.users.root.initialHashedPassword = "$y$j9T$bIN6GjQkmPMllOcQsq52K0$q0Z5B5.KW/uxXK9fItB8H6HO79RYAcI/ZZdB0Djke32";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.05"; # Did you read the comment?
}
