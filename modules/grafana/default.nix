{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  age.secrets.grafana-admin-password = {
    file = "${flake.self}/secrets/grafana-admin-password.age";
    mode = "440";
    owner = "grafana";
  };
  age.secrets.grafana-smtp-password = {
    file = "${flake.self}/secrets/grafana-smtp-password.age";
    mode = "440";
    owner = "grafana";
  };
  age.secrets.grafana-keycloak-client-secret = {
    file = "${flake.self}/secrets/grafana-keycloak-client-secret.age";
    mode = "440";
    owner = "grafana";
  };

  environment.etc = {
    "grafana-dashboards/node-exporter-full_rev33.json" = {
      source = ./grafana-dashboards/node-exporter-full_rev33.json;
      group = "grafana";
      user = "grafana";
    };
    "grafana-dashboards/synapse.json" = {
      source = ./grafana-dashboards/synapse.json;
      group = "grafana";
      user = "grafana";
    };
    "grafana-dashboards/grafana-garage-dashboard-prometheus.json" = {
      source = ./grafana-dashboards/grafana-garage-dashboard-prometheus.json;
      group = "grafana";
      user = "grafana";
    };
  };

  services.nginx.virtualHosts."grafana.${config.pub-solar-os.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass =
      "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        # Listening Address
        http_addr = "127.0.0.1";
        # and Port
        http_port = 3000;
        # Grafana needs to know on which domain and URL it's running
        domain = "grafana.${config.pub-solar-os.networking.domain}";
        root_url = "https://grafana.${config.pub-solar-os.networking.domain}";
        enable_gzip = true;
      };
      smtp = {
        enabled = true;
        host = "mail.pub.solar:465";
        user = "admins@pub.solar";
        password = "\$__file{${config.age.secrets.grafana-smtp-password.path}}";
        from_address = "no-reply@pub.solar";
        from_name = "grafana.pub.solar";
        ehlo_identity = "grafana.pub.solar";
      };
      security = {
        admin_email = "crew@pub.solar";
        admin_password = "\$__file{${config.age.secrets.grafana-admin-password.path}}";
      };
      "auth.generic_oauth" = {
        enabled = true;
        name = "pub.solar ID";
        allow_sign_up = true;
        client_id = "grafana";
        client_secret = "\$__file{${config.age.secrets.grafana-keycloak-client-secret.path}}";
        scopes = "openid email profile offline_access roles";
        email_attribute_path = "email";
        login_attribute_path = "preferred_username";
        name_attribute_path = "full_name";
        auth_url = "https://auth.${config.pub-solar-os.networking.domain}/realms/${config.pub-solar-os.auth.realm}/protocol/openid-connect/auth";
        token_url = "https://auth.${config.pub-solar-os.networking.domain}/realms/${config.pub-solar-os.auth.realm}/protocol/openid-connect/token";
        api_url = "https://auth.${config.pub-solar-os.networking.domain}/realms/${config.pub-solar-os.auth.realm}/protocol/openid-connect/userinfo";
        role_attribute_path = "contains(roles[*], 'admin') && 'GrafanaAdmin' || 'Viewer'";
        allow_assign_grafana_admin = true;
      };
    };
    provision = {
      enable = true;
      datasources = {
        settings = {
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "http://127.0.0.1:${toString config.services.prometheus.port}";
              isDefault = true;
            }
            {
              name = "Loki";
              type = "loki";
              access = "proxy";
              url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
            }
          ];
        };
      };
      dashboards = {
        settings = {
          providers = [
            {
              name = "pub.solar Dashboards";
              options.path = "/etc/grafana-dashboards";
            }
          ];
        };
      };
    };
  };
}
