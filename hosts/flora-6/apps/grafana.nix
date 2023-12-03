{
  config,
  lib,
  pkgs,
  flake,
  ...
}: {
  age.secrets.grafana-admin-password = {
    file = "${flake.self}/secrets/grafana-admin-password.age";
    mode = "644";
    owner = "grafana";
  };
  age.secrets.grafana-smtp-password = {
    file = "${flake.self}/secrets/grafana-smtp-password.age";
    mode = "644";
    owner = "grafana";
  };
  age.secrets.grafana-keycloak-client-secret = {
    file = "${flake.self}/secrets/grafana-keycloak-client-secret.age";
    mode = "644";
    owner = "grafana";
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
        domain = "grafana.pub.solar";
        root_url = "https://grafana.pub.solar";
        enable_gzip = true;
      };
      smtp = {
        enabled = true;
        host = "mx2.greenbaum.cloud:465";
        user = "admins@pub.solar";
        password = "\$__file{${config.age.secrets.grafana-smtp-password.path}}";
        from_address = "no-reply@pub.solar";
        from_name = "grafana.pub.solar";
        ehlo_identity = "flora-6.pub.solar";
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
        auth_url = "https://auth.pub.solar/realms/pub.solar/protocol/openid-connect/auth";
        token_url = "https://auth.pub.solar/realms/pub.solar/protocol/openid-connect/token";
        api_url = "https://auth.pub.solar/realms/pub.solar/protocol/openid-connect/userinfo";
        role_attribute_path = "contains(roles[*], 'admin') && 'GrafanaAdmin' || contains(roles[*], 'editor') && 'Editor' || 'Viewer'";
        allow_assign_grafana_admin = true;
      };
    };
  };
}
