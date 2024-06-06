{
  config,
  pkgs,
  flake,
  ...
}:
{
  networking.firewall.allowedUDPPorts = [ 51820 ];

  age.secrets.wg-private-key.file = "${flake.self}/secrets/flora6-wg-private-key.age";

  networking.wireguard.interfaces = {
    wg-ssh = {
      listenPort = 51820;
      mtu = 1300;
      ips = [
        "10.7.6.2/32"
        "fd00:fae:fae:fae:fae:2::/96"
      ];
      privateKeyFile = config.age.secrets.wg-private-key.path;
      peers = flake.self.logins.admins.wireguardDevices ++ [
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
          # metronom.pub.solar
          endpoint = "49.13.236.167:51820";
          publicKey = "zOSYGO7MfnOOUnzaTcWiKRQM0qqxR3JQrwx/gtEtHmo=";
          allowedIPs = [
            "10.7.6.3/32"
            "fd00:fae:fae:fae:fae:3::/96"
          ];
          persistentKeepalive = 15;
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
      addr = "10.7.6.2";
      port = 22;
    }
    {
      addr = "[fd00:fae:fae:fae:fae:2::]";
      port = 22;
    }
  ];
}
