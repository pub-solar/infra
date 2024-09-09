{
  config,
  pkgs,
  flake,
  ...
}:
let
  wireguardIPv4 = "10.7.6.6";
  wireguardIPv6 = "fd00:fae:fae:fae:fae:6::";
in
{
  networking.firewall.allowedUDPPorts = [ 51820 ];

  age.secrets.wg-private-key.file = "${flake.self}/secrets/delite-wg-private-key.age";

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
          # trinkgenossin.pub.solar
          publicKey = "QWgHovHxtqiQhnHLouSWiT6GIoQDmuvnThYL5c/rvU4=";
          allowedIPs = [
            "10.7.6.5/32"
            "fd00:fae:fae:fae:fae:5::/96"
          ];
          #endpoint = "80.244.242.5:51820";
          endpoint = "[2a01:239:35d:f500::1]:51820";
          persistentKeepalive = 15;
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
