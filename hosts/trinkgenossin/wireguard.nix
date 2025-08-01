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
      peers = (flake.self.lib.wireguardDevicesForUsers config.pub-solar-os.authentication.users) ++ [
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
          endpoint = "[2001:4d88:1ffa:26::5]:51820";
          publicKey = "iRTlY1lB7nPXf2eXzX8ZZDkfMmXyGjff5/joccbP8Cg=";
          allowedIPs = [
            "10.7.6.4/32"
            "fd00:fae:fae:fae:fae:4::/96"
          ];
        }
        {
          # delite.pub.solar
          endpoint = "5.255.119.132:51820";
          publicKey = "ZT2qGWgMPwHRUOZmTQHWCRX4m14YwOsiszjsA5bpc2k=";
          allowedIPs = [
            "10.7.6.6/32"
            "fd00:fae:fae:fae:fae:6::/96"
          ];
        }
        {
          # blue-shell.pub.solar
          endpoint = "194.13.83.205:51820";
          publicKey = "bcrIpWrKc1M+Hq4ds3aN1lTaKE26f2rvXhd+93QrzR8=";
          allowedIPs = [
            "10.7.6.7/32"
            "fd00:fae:fae:fae:fae:7::/96"
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
