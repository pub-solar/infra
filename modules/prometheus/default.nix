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
  age.secrets.alertmanager-envfile = {
    file = "${flake.self}/secrets/alertmanager-envfile.age";
    mode = "600";
    owner = "alertmanager";
  };

  services.caddy.virtualHosts."alerts.${config.pub-solar-os.networking.domain}" = {
    logFormat = lib.mkForce ''
      output discard
    '';
    extraConfig = ''
      bind 10.7.6.2 fd00:fae:fae:fae:fae:2::
      tls internal
      reverse_proxy :${toString config.services.prometheus.alertmanager.port}
    '';
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

    ruleFiles = [
      (pkgs.writeText "prometheus-rules.yml" (
        builtins.toJSON {
          groups = [
            {
              name = "alerting-rules";
              rules = import ./alert-rules.nix { inherit lib; };
            }
          ];
        }
      ))
    ];

    alertmanagers = [ { static_configs = [ { targets = [ "localhost:9093" ]; } ]; } ];

    alertmanager = {
      enable = true;
      # port = 9093; # Default
      webExternalUrl = "https://alerts.pub.solar";
      environmentFile = "${config.age.secrets.alertmanager-envfile.path}";
      configuration = {

        route = {
          receiver = "all";
          group_by = [ "instance" ];
          group_wait = "30s";
          group_interval = "2m";
          repeat_interval = "24h";
        };

        receivers = [
          {
            name = "all";
            # Email config documentation: https://prometheus.io/docs/alerting/latest/configuration/#email_config
            email_configs = [
              {
                send_resolved = true;
                to = "admins@pub.solar";
                from = "alerts@pub.solar";
                smarthost = "mail.pub.solar:465";
                auth_username = "admins@pub.solar";
                auth_password = "$SMTP_AUTH_PASSWORD";
                require_tls = false;
              }
            ];
            # TODO:
            # For matrix notifications, look into: https://github.com/pinpox/matrix-hook and add a webhook
            #   webhook_configs = [ { url = "http://127.0.0.1:11000/alert"; } ];
          }
        ];
      };
    };
  };
}
