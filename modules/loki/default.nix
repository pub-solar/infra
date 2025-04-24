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
      pattern_ingester.enabled = true;
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
        chunk_cache_config = {
          embedded_cache = {
            enabled = true;
            max_size_mb = 500;
            ttl = "24h";
          };
        };
      };
      # Keep logs for 1 week
      # https://grafana.com/docs/loki/latest/operations/storage/retention/
      limits_config = {
        allow_structured_metadata = true;
        ingestion_rate_mb = 8;
        ingestion_burst_size_mb = 12;
        retention_period = "1w";
        split_queries_by_interval = "0";
        volume_enabled = true;
      };
      compactor = {
        compaction_interval = "10m";
        delete_request_store = "filesystem";
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
          {
            from = "2024-05-31";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };
    };
  };
}
