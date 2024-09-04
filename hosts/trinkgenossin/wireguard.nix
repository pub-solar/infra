{
  config,
  pkgs,
  flake,
  ...
}:
let
  wireguardIPv4 = "10.7.6.5";
  wireguardIPv6 = "fd00:fae:fae:fae:fae:5::";
in
{
  networking.firewall.allowedUDPPorts = [ 51820 ];

  age.secrets.wg-private-key.file = "${flake.self}/secrets/trinkgenossin-wg-private-key.age";

  networking.wireguard.interfaces = {
    wg-ssh = {
      listenPort = 51820;
      mtu = 1300;
      ips = [
        "${wireguardIPv4}/32"
        "${wireguardIPv6}/96"
      ];
      privateKeyFile = config.age.secrets.wg-private-key.path;
      peers = flake.self.logins.admins.wireguardDevices ++ [
        {
          # flora-6.pub.solar
          endpoint = "80.71.153.210:51820";
          publicKey = "jtSR5G2P/nm9s8WrVc26Xc/SQLupRxyXE+5eIeqlsTU=";
          allowedIPs = [
            "10.7.6.2/32"
            "fd00:fae:fae:fae:fae:2::/96"
          ];
        }
      ];
    };
  };

  services.openssh.listenAddresses = [
    {
      addr = wireguardIPv4;
      port = 22;
    }
    {
      addr = "[${wireguardIPv6}]";
      port = 22;
    }
  ];
}
