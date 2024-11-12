{
  config,
  pkgs,
  flake,
  ...
}:
{
  networking.firewall.allowedUDPPorts = [ 51820 ];

  age.secrets.wg-private-key.file = "${flake.self}/secrets/tankstelle-wg-private-key.age";

  networking.wireguard.interfaces = {
    wg-ssh = {
      listenPort = 51820;
      mtu = 1300;
      ips = [
        "10.7.6.4/32"
        "fd00:fae:fae:fae:fae:4::/96"
      ];
      privateKeyFile = config.age.secrets.wg-private-key.path;
      peers = flake.self.logins.wireguardDevices ++ [
        {
          # nachtigall.pub.solar
          endpoint = "138.201.80.102:51820";
          publicKey = "qzNywKY9RvqTnDO8eLik75/SHveaSk9OObilDzv+xkk=";
          allowedIPs = [
            "10.7.6.1/32"
            "fd00:fae:fae:fae:fae:1::/96"
          ];
        }
        {
          # trinkgenossin.pub.solar
          publicKey = "QWgHovHxtqiQhnHLouSWiT6GIoQDmuvnThYL5c/rvU4=";
          allowedIPs = [
            "10.7.6.5/32"
            "fd00:fae:fae:fae:fae:5::/96"
          ];
          #endpoint = "85.215.152.22:51820";
          endpoint = "[2a01:239:35d:f500::1]:51820";
          persistentKeepalive = 15;
        }
      ];
    };
  };

  services.openssh.listenAddresses = [
    {
      addr = "10.7.6.4";
      port = 22;
    }
    {
      addr = "[fd00:fae:fae:fae:fae:4::]";
      port = 22;
    }
  ];
}
