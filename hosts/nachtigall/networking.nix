{
  config,
  pkgs,
  flake,
  ... }:
{

  networking.hostName = "nachtigall";
  networking.domain = "pub.solar";
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
  networking.defaultGateway6 = { address = "fe80::1"; interface = "enp35s0"; };

  networking.firewall.allowedUDPPorts = [ 51899 ];

  age.secrets.wg-private-key.file = "${flake.self}/secrets/nachtigall-wg-private-key.age";

  networking.wireguard.interfaces = {
    wg-ssh = {
      listenPort = 51899;
      mtu = 1300;
      ips = [
        "10.7.6.1/32"
        "fd00:fae:fae:fae:fae:1::/96"
      ];
      privateKeyFile = config.age.secrets.wg-private-key.path;
      peers = flake.self.logins.admins.wireguardDevices ++ [
        { # flora6
          publicKey = "jtSR5G2P/nm9s8WrVc26Xc/SQLupRxyXE+5eIeqlsTU=";
          allowedIPs = [ ];
          persistentKeepalive = 30;
          dynamicEndpointRefreshSeconds = 30;
        }
      ];
    };
  };
}
