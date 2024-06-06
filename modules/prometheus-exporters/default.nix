{ config, ... }:
{
  # Only expose prometheus exporter port via wireguard interface
  networking.firewall.interfaces.wg-ssh.allowedTCPPorts = [ 9002 ];

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };
}
