{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
let
  # TODO add hosts here
  blackboxTargets = [ "https://pablo.tools" ];
in
{
  age.secrets.alertmanager-envfile = {
    file = "${flake.self}/secrets/alertmanager-envfile.age";
    mode = "600";
    owner = "alertmanager";
  };

  security.acme.certs = {
    "alerts.${config.pub-solar-os.networking.domain}" = {
      # disable http challenge
      webroot = null;
      # enable dns challenge
      dnsProvider = "namecheap";
    };
  };

  services.nginx.virtualHosts."alerts.${config.pub-solar-os.networking.domain}" = {
    enableACME = true;
    forceSSL = true;

    listenAddresses = [
      "10.7.6.5"
      "[fd00:fae:fae:fae:fae:5::]"
    ];

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.prometheus.alertmanager.port}";
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      blackbox = {
        enable = true;
        # Default port is 9115
        openFirewall = false;

        configFile = pkgs.writeTextFile {
          name = "blackbox-exporter-config";
          text = ''
            modules:
              http_2xx:
                prober: http
                timeout: 5s
                http:
                  valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
                  valid_status_codes: []  # Defaults to 2xx
                  method: GET
                  no_follow_redirects: false
                  fail_if_ssl: false
                  fail_if_not_ssl: false
                  tls_config:
                    insecure_skip_verify: false
                  preferred_ip_protocol: "ip4" # defaults to "ip6"
                  ip_protocol_fallback: true  # fallback to "ip6"
          '';
        };
      };
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
        job_name = "blackbox";
        scrape_interval = "5m";
        metrics_path = "/probe";
        params = {
          module = [ "http_2xx" ];
        };
        static_configs = [ { targets = blackboxTargets; } ];

        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "127.0.0.1:9115"; # The blackbox exporter's real hostname:port.
          }
        ];
      }
      {
        job_name = "node-exporter";
        static_configs = [
          {
            targets = [ "nachtigall.wg.${config.pub-solar-os.networking.domain}" ];
            labels = {
              instance = "nachtigall";
            };
          }
          {
            targets = [
              "metronom.wg.${config.pub-solar-os.networking.domain}:${toString config.services.prometheus.exporters.node.port}"
            ];
            labels = {
              instance = "metronom";
            };
          }
          {
            targets = [
              "tankstelle.wg.${config.pub-solar-os.networking.domain}:${toString config.services.prometheus.exporters.node.port}"
            ];
            labels = {
              instance = "tankstelle";
            };
          }
          {
            targets = [
              "trinkgenossin.wg.${config.pub-solar-os.networking.domain}:${toString config.services.prometheus.exporters.node.port}"
            ];
            labels = {
              instance = "trinkgenossin";
            };
          }
          {
            targets = [
              "delite.wg.${config.pub-solar-os.networking.domain}:${toString config.services.prometheus.exporters.node.port}"
            ];
            labels = {
              instance = "delite";
            };
          }
          {
            targets = [
              "blue-shell.wg.${config.pub-solar-os.networking.domain}:${toString config.services.prometheus.exporters.node.port}"
            ];
            labels = {
              instance = "blue-shell";
            };
          }
        ];
      }
      {
        job_name = "matrix-synapse";
        metrics_path = "/_synapse/metrics";
        static_configs = [
          {
            targets = [ "nachtigall.wg.${config.pub-solar-os.networking.domain}" ];
            labels = {
              instance = "nachtigall";
            };
          }
        ];
      }
      {
        job_name = "garage";
        static_configs = [
          {
            targets = [ "trinkgenossin.wg.${config.pub-solar-os.networking.domain}:3903" ];
            labels = {
              instance = "trinkgenossin";
            };
          }
          {
            targets = [ "delite.wg.${config.pub-solar-os.networking.domain}:3903" ];
            labels = {
              instance = "delite";
            };
          }
          {
            targets = [ "blue-shell.wg.${config.pub-solar-os.networking.domain}:3903" ];
            labels = {
              instance = "blue-shell";
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
