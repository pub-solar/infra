{
  config,
  pkgs,
  flake,
  ...
}:
{
  networking.firewall.allowedUDPPorts = [ 51820 ];

  age.secrets.wg-private-key.file = "${flake.self}/secrets/nachtigall-wg-private-key.age";

  networking.wireguard.interfaces = {
    wg-ssh = {
      listenPort = 51820;
      mtu = 1300;
      ips = [
        "10.7.6.1/32"
        "fd00:fae:fae:fae:fae:1::/96"
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
        {
          # tankstelle.pub.solar
          endpoint = "80.244.242.5:51820";
          publicKey = "iRTlY1lB7nPXf2eXzX8ZZDkfMmXyGjff5/joccbP8Cg=";
          allowedIPs = [
            "10.7.6.4/32"
            "fd00:fae:fae:fae:fae:4::/96"
          ];
        }
      ];
    };
  };

  services.openssh.listenAddresses = [
    {
      addr = "10.7.6.1";
      port = 22;
    }
    {
      addr = "[fd00:fae:fae:fae:fae:1::]";
      port = 22;
    }
  ];
}
