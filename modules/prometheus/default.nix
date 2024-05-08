{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  age.secrets.nachtigall-metrics-prometheus-basic-auth-password = {
    file = "${flake.self}/secrets/nachtigall-metrics-prometheus-basic-auth-password.age";
    mode = "600";
    owner = "prometheus";
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
    globalConfig = {
      scrape_interval = "10s";
      scrape_timeout = "9s";
    };
    scrapeConfigs = [
      {
        job_name = "node-exporter-http";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
            labels = {
              instance = "flora-6";
            };
          }
        ];
      }
      {
        job_name = "node-exporter-https";
        scheme = "https";
        metrics_path = "/metrics";
        basic_auth = {
          username = "hakkonaut";
          password_file = "${config.age.secrets.nachtigall-metrics-prometheus-basic-auth-password.path}";
        };
        static_configs = [
          {
            targets = [ "nachtigall.${config.pub-solar-os.networking.domain}" ];
            labels = {
              instance = "nachtigall";
            };
          }
        ];
      }
      {
        job_name = "matrix-synapse";
        scheme = "https";
        metrics_path = "/_synapse/metrics";
        basic_auth = {
          username = "hakkonaut";
          password_file = "${config.age.secrets.nachtigall-metrics-prometheus-basic-auth-password.path}";
        };
        static_configs = [
          {
            targets = [ "nachtigall.${config.pub-solar-os.networking.domain}" ];
            labels = {
              instance = "nachtigall";
            };
          }
        ];
      }
    ];
  };
}
