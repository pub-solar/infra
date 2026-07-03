{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
let
  cfg = config.pub-solar-os.alloy;
  trinkgenossinCfg = flake.self.nixosConfigurations.trinkgenossin.config;
in
{
  options.pub-solar-os.alloy = {
    http-listen-port = lib.mkOption {
      description = "HTTP for alloy";
      type = lib.types.port;
      default = 12345;
    };
  };

  config = {
    # Only expose alloy UI and metrics port via wireguard interface
    networking.firewall.interfaces.wg-ssh.allowedTCPPorts = [
      cfg.http-listen-port
    ];
    environment.etc = {
      "alloy/template.alloy" = {
        source = ./template.alloy;
      };
      "alloy/config.alloy" = {
        text = ''
          import.file "template" {
            filename = "/etc/alloy/template.alloy"
          }
          template.logs_and_metrics "default" {
            loki_host = "trinkgenossin.wg.pub.solar"
            loki_port = ${toString trinkgenossinCfg.services.loki.configuration.server.http_listen_port}

            prometheus_host = "trinkgenossin.wg.pub.solar"
            prometheus_port = ${toString trinkgenossinCfg.services.prometheus.port}

            host = "${config.networking.hostName}"
          }
        '';
      };
    };

    services.alloy = {
      enable = true;
      extraFlags = [
        "--server.http.listen-addr=0.0.0.0:${toString cfg.http-listen-port}"
      ];
    };
  };
}
