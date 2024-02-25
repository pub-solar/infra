{ ... }:

{
  systemd.tmpfiles.rules = [
    "d '/srv/www/pub.solar' 0750 hakkonaut hakkonaut - -"
  ];

  services.nginx.virtualHosts = {
    "www.pub.solar" = {
      enableACME = true;
      addSSL = true;

      extraConfig = ''
        error_log /dev/null;
        access_log /dev/null;
      '';

      locations."/" = {
        extraConfig = ''
          return 301 https://pub.solar$request_uri;
        '';
      };
    };

    "pub.solar" = {
      default = true;
      enableACME = true;
      forceSSL = true;

      extraConfig = ''
        error_log /dev/null;
        access_log /dev/null;
      '';

      locations = {
        # serve base domain pub.solar for mastodon.pub.solar
        # https://masto.host/mastodon-usernames-different-from-the-domain-used-for-installation/
        "/.well-known/host-meta" = {
          extraConfig = ''
            return 301 https://mastodon.pub.solar$request_uri;
          '';
        };

        # Tailscale OIDC webfinger requirement plus Mastodon webfinger redirect
        "/.well-known/webfinger" = {
          # Redirect requests that match /.well-known/webfinger?resource=* to Mastodon
          extraConfig = ''
            if ($arg_resource) {
              return 301 https://mastodon.pub.solar$request_uri;
            }

            add_header Content-Type text/plain;
            return 200 '{\n  "subject": "acct:admins@pub.solar",\n  "links": [\n    {\n    "rel": "http://openid.net/specs/connect/1.0/issuer",\n    "href": "https://auth.pub.solar/realms/pub.solar"\n    }\n  ]\n}';
          '';
        };

        "/satzung" = {
          extraConfig = ''
            return 302 https://cloud.pub.solar/s/iaKqiW25QJpHPYs;
          '';
        };

        "/" = {
          root = "/srv/www/pub.solar";
          index = "index.html";
          tryFiles = "$uri $uri/ =404";
        };
      };
    };
  };
}
