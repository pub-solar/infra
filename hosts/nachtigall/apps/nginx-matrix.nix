{ lib, pkgs, ... }:
let
  commonHeaders = ''
    add_header Permissions-Policy interest-cohort=() always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-XSS-Protection "1; mode=block";
  '';
  clientConfig = import ./matrix/element-client-config.nix { inherit lib pkgs; };
  wellKnownClient = domain: {
    "m.homeserver".base_url = "https://matrix.${domain}";
    "m.identity_server".base_url = "https://matrix.${domain}";
    "org.matrix.msc3575.proxy".url = "https://matrix.${domain}/sliding-sync";
    "im.vector.riot.e2ee".default = true;
    "io.element.e2ee" = {
      default = true;
      secure_backup_required = false;
      secure_backup_setup_methods = [];
    };
    "m.integrations" = {
      managers = [
        {
          api_url = "https://dimension.${domain}/api/v1/scalar";
          ui_url = "https://dimension.${domain}/element";
        }
      ];
    };
  };
  wellKnownServer = domain: { "m.server" = "matrix.${domain}:8448"; };
  wellKnownSupport = {
    contacts = [
        {
            email_address = "crew@pub.solar";
            matrix_id = "@b12f:pub.solar";
            role = "m.role.admin";
        }
        {
            email_address = "crew@pub.solar";
            matrix_id = "@hensoko:pub.solar";
            role = "m.role.admin";
        }
        {
            email_address = "crew@pub.solar";
            matrix_id = "@teutat3s:pub.solar";
            role = "m.role.admin";
        }
    ];
    support_page = "https://pub.solar/about";
  };
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
  wellKnownLocations = domain: {
    "= /.well-known/matrix/server".extraConfig = mkWellKnown (wellKnownServer domain);
    "= /.well-known/matrix/client".extraConfig = mkWellKnown (wellKnownClient domain);
    "= /.well-known/matrix/support".extraConfig = mkWellKnown wellKnownSupport;
  };
in
{
  services.nginx.virtualHosts = {

    #####################################
    # This is already in production use #
    #####################################

    "pub.solar" = {
      locations = wellKnownLocations "pub.solar";
    };

    "chat.pub.solar" = {
      forceSSL = true;
      enableACME = true;
      root = pkgs.element-web.override {
        conf = clientConfig;
      };
    };

    "matrix.pub.solar" = {
      root = "/dev/null";

      forceSSL = lib.mkDefault true;
      enableACME = lib.mkDefault true;

      extraConfig = ''
        server_tokens off;
        gzip on;
        gzip_types text/plain application/json;
      '';
      locations = {
        # TODO: Configure metrics
        # "/metrics" = {
        # };

        # For telegram
        "/c3c3f34b-29fb-5feb-86e5-98c75ec8214b" = {
          proxyPass = "http://127.0.0.1:8009";
          extraConfig = commonHeaders;
        };

        "~* ^(/_matrix|/_synapse/client|/_synapse/oidc)" = {
          proxyPass = "http://127.0.0.1:8008";

          extraConfig = ''
            ${commonHeaders}
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;

            client_body_buffer_size 25M;
            client_max_body_size 50M;
            proxy_max_temp_file_size 0;
          '';
        };
      };
    };
    "matrix.pub.solar-federation" = {
      serverName = "matrix.pub.solar";
      forceSSL = lib.mkDefault true;
      enableACME = lib.mkDefault true;
      listen = [{
        port = 8448;
        addr = "0.0.0.0";
        ssl = true;
      } {
        port = 8448;
        addr = "[::]";
        ssl = true;
      }];
      root = "/dev/null";
      extraConfig = ''
        server_tokens off;

        gzip on;
        gzip_types text/plain application/json;
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:8008";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;

          client_body_buffer_size 25M;
          client_max_body_size 150M;
          proxy_max_temp_file_size 0;
        '';
      };
    };
  };
  networking.firewall.allowedTCPPorts = [8448];
}

