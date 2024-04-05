{
  config,
  pkgs,
  flake,
  ... }:
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
          endpoint = "flora-6.pub.solar:51820";
          publicKey = "jtSR5G2P/nm9s8WrVc26Xc/SQLupRxyXE+5eIeqlsTU=";
          allowedIPs = [ "10.7.6.2/32" "fd00:fae:fae:fae:fae:2::/96" ];
        }
      ];
    };
  };
}
