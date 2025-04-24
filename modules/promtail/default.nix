{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 9080;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [
        {
          url = "http://trinkgenossin.wg.pub.solar:${toString flake.self.nixosConfigurations.trinkgenossin.config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
        }
      ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "24h";
            labels = {
              job = "systemd-journal";
              host = config.networking.hostName;
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" "__journal__systemd_user_unit" ];
              target_label = "service";
            }
            {
              source_labels = [ "__journal_priority_keyword" ];
              target_label = "severity";
            }
          ];
        }
      ];
    };
  };
}
