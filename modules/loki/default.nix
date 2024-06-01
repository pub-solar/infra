{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  # source: https://gist.github.com/rickhull/895b0cb38fdd537c1078a858cf15d63e
  # https://grafana.com/docs/loki/latest/configure/examples/#1-local-configuration-exampleyaml
  services.loki = {
    enable = true;
    configuration = {
      server.http_listen_port = 3100;
      auth_enabled = false;
      common = {
        ring = {
          instance_interface_names = [ "wg-ssh" ];
          instance_enable_ipv6 = true;
          kvstore = {
            store = "inmemory";
          };
        };
        replication_factor = 1;
        path_prefix = "/var/lib/loki";
        storage = {
          filesystem = {
            chunks_directory = "chunks/";
            rules_directory = "rules/";
          };
        };
      };
      # Keep logs for 4 weeks
      # https://grafana.com/docs/loki/latest/operations/storage/retention/
      limits_config.retention_period = "4w";
      compactor = {
        shared_store = "filesystem";
        compaction_interval = "10m";
        retention_enabled = true;
        retention_delete_delay = "2h";
        retention_delete_worker_count = 150;
      };
      schema_config = {
        configs = [
          {
            from = "2020-05-15";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };
    };
  };

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
          url = "http://flora-6.wg.pub.solar:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
        }
      ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "24h";
            labels = {
              job = "systemd-journal";
              host = "flora-6";
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
}
