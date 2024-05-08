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
    owner = "promtail";
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
          url = "https://flora-6.${config.pub-solar-os.networking.domain}/loki/api/v1/push";
          basic_auth = {
            username = "hakkonaut";
            password_file = "${config.age.secrets.nachtigall-metrics-prometheus-basic-auth-password.path}";
          };
        }
      ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "24h";
            labels = {
              job = "systemd-journal";
              host = "nachtigall";
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
