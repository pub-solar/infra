{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  # Only expose loki port via wireguard interface
  networking.firewall.interfaces.wg-ssh.allowedTCPPorts = [ 3100 ];

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
      ingester = {
        chunk_encoding = "snappy";
        chunk_idle_period = "1h";
      };
      query_range = {
        results_cache = {
          cache = {
            embedded_cache = {
              enabled = true;
              max_size_mb = 500;
            };
          };
        };
      };
      chunk_store_config = {
        max_look_back_period = "0s";
        chunk_cache_config = {
          embedded_cache = {
            enabled = true;
            max_size_mb = 500;
            ttl = "24h";
          };
        };
      };
      # Keep logs for 4 weeks
      # https://grafana.com/docs/loki/latest/operations/storage/retention/
      limits_config = {
        retention_period = "4w";
        split_queries_by_interval = "0";
      };
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
