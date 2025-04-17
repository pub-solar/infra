{ config, ... }:
{
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        openFirewall = true;
        firewallRules = [
          ''iifname "wg-ssh" tcp dport ${config.services.prometheus.exporters.node.port} accept''
        ];
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };
}
