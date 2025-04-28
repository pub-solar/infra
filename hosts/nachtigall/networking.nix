{
  config,
  pkgs,
  flake,
  ...
}:
{
  systemd.services.nscd.environment = {
    NSNCD_WORKER_COUNT = "16";
    NSNCD_HANDOFF_TIMEOUT = "6";
  };

  networking.hosts = {
    "138.201.80.102" = [ "nachtigall.${config.pub-solar-os.networking.domain}" ];
    "2a01:4f8:172:1c25::1" = [ "nachtigall.${config.pub-solar-os.networking.domain}" ];
  };

  networking.hostName = "nachtigall";
  networking.hostId = "00000001";

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
  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "enp35s0";
  };
}
