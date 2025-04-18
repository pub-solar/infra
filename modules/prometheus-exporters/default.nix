{ config, ... }:
{
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        openFirewall = true;
        firewallFilter = "--in-interface wg-ssh --protocol tcp --match tcp --dport ${toString config.services.prometheus.exporters.node.port}";
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };
}
