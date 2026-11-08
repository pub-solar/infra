{
  config,
  pkgs,
  flake,
  ...
}:
{
  age.secrets."acme-hostingde-api-key" = {
    file = "${flake.self}/secrets/acme-hostingde-api-key.age";
    mode = "400";
  };

  security.acme = {
    defaults = {
      credentialFiles = {
        "HOSTINGDE_API_KEY_FILE" = config.age.secrets.acme-hostingde-api-key.path;
      };
      extraLegoFlags = [ "--dns.resolvers=ns1.hosting.de:53" ];
    };
    certs = {
      "buckets.${config.pub-solar-os.networking.domain}" = {
        extraDomainNames = [ "*.buckets.${config.pub-solar-os.networking.domain}" ];
        # disable http challenge
        webroot = null;
        # enable dns challenge
        dnsProvider = "hostingde";
      };
      "web.${config.pub-solar-os.networking.domain}" = {
        extraDomainNames = [ "*.web.${config.pub-solar-os.networking.domain}" ];
        # disable http challenge
        webroot = null;
        # enable dns challenge
        dnsProvider = "hostingde";
      };
    };
  };
  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    upstreams.s3_backend.servers = {
      "[::1]:3900" = { };
    };
    upstreams.web_backend.servers = {
      "[::1]:3902" = { };
    };
  };

  # Change nginx default ports to allow haproxy tcp forwarding,
  # mainly to allow usage of codeberg-pages with custom domains
  services.nginx = {
    defaultHTTPListenPort = 8080;
    defaultSSLListenPort = 8443;

    virtualHosts."buckets.${config.pub-solar-os.networking.domain}" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8443;
          proxyProtocol = true;
          ssl = true;
        }
      ];

      serverAliases = [ "*.buckets.${config.pub-solar-os.networking.domain}" ];

      useACMEHost = "buckets.${config.pub-solar-os.networking.domain}";
      forceSSL = true;

      extraConfig = ''
        access_log /var/log/nginx/buckets.${config.pub-solar-os.networking.domain}-access.log combined_host;
        error_log /var/log/nginx/buckets.${config.pub-solar-os.networking.domain}-error.log;
      '';

      locations."/" = {
        proxyPass = "http://s3_backend";
        extraConfig = ''
          client_max_body_size 64m;
          proxy_max_temp_file_size 0;
        '';
      };
    };

    virtualHosts."web.${config.pub-solar-os.networking.domain}" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8443;
          proxyProtocol = true;
          ssl = true;
        }
      ];

      serverAliases = [ "*.web.${config.pub-solar-os.networking.domain}" ];

      useACMEHost = "web.${config.pub-solar-os.networking.domain}";
      forceSSL = true;

      extraConfig = ''
        access_log /var/log/nginx/web.${config.pub-solar-os.networking.domain}-access.log combined_host;
        error_log /var/log/nginx/web.${config.pub-solar-os.networking.domain}-error.log;
      '';

      locations."/" = {
        proxyPass = "http://web_backend";
      };
    };
  };
}
