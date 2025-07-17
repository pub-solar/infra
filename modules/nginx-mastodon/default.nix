{ config, lib, ... }:
let
  cfg = config.services.mastodon;
  nginxCommonHeaders = ''
    add_header Cache-Control 'public, max-age=2419200, must-revalidate';
    add_header Strict-Transport-Security 'max-age=63072000';
  '';
in
{
  services.nginx = {
    proxyCachePath = {
      "mastodon" = {
        enable = true;
        keysZoneName = "mastodon";
        inactive = "7d";
      };
    };
    virtualHosts = {
      "mastodon.${config.pub-solar-os.networking.domain}" = {
        root = "${cfg.package}/public";
        # mastodon only supports https, but you can override this if you offload tls elsewhere.
        forceSSL = lib.mkDefault true;
        enableACME = lib.mkDefault true;
        extraConfig = ''
          client_max_body_size 99m;
          error_page 404 500 501 502 503 504 /500.html;
        '';

        locations."/auth/sign_up" = {
          priority = 900;
          extraConfig = ''
            return 302 /auth/sign_in;
          '';
        };

        locations."/auth/confirmation/new" = {
          priority = 910;
          extraConfig = ''
            return 302 https://auth.${config.pub-solar-os.networking.domain}/realms/${config.pub-solar-os.auth.realm}/login-actions/reset-credentials?client_id=mastodon;
          '';
        };

        locations."/auth/password/new" = {
          priority = 920;
          extraConfig = ''
            return 302 https://auth.${config.pub-solar-os.networking.domain}/realms/${config.pub-solar-os.auth.realm}/login-actions/reset-credentials?client_id=mastodon;
          '';
        };

        locations."/" = {
          priority = 1100;
          tryFiles = "$uri @mastodon";
        };

        locations."/sw.js" = {
          priority = 3100;
          extraConfig = ''
            add_header Cache-Control 'public, max-age=604800, must-revalidate';
            add_header Strict-Transport-Security 'max-age=63072000';
          '';
          tryFiles = "$uri =404";
        };

        locations."~ ^/assets/" = {
          priority = 3110;
          extraConfig = nginxCommonHeaders;
          tryFiles = "$uri =404";
        };

        locations."~ ^/avatars/" = {
          priority = 3120;
          extraConfig = nginxCommonHeaders;
          tryFiles = "$uri =404";
        };

        locations."~ ^/emoji/" = {
          priority = 3130;
          extraConfig = nginxCommonHeaders;
          tryFiles = "$uri =404";
        };

        locations."~ ^/headers/" = {
          priority = 3140;
          extraConfig = nginxCommonHeaders;
          tryFiles = "$uri =404";
        };

        locations."~ ^/packs/" = {
          priority = 3150;
          extraConfig = nginxCommonHeaders;
          tryFiles = "$uri =404";
        };

        locations."~ ^/shortcuts/" = {
          priority = 3160;
          extraConfig = nginxCommonHeaders;
          tryFiles = "$uri =404";
        };

        locations."~ ^/sounds/" = {
          priority = 3170;
          extraConfig = nginxCommonHeaders;
          tryFiles = "$uri =404";
        };

        locations."~ ^/system/" = {
          priority = 3180;
          alias = "/var/lib/mastodon/public-system/";
          extraConfig = ''
            add_header Cache-Control 'public, max-age=2419200, immutable';
            add_header Strict-Transport-Security 'max-age=63072000';
            add_header X-Content-Type-Options 'nosniff';
            add_header Content-Security-Policy "default-src 'none'; form-action 'none'";
          '';
          tryFiles = "$uri =404";
        };

        locations."^~ /api/v1/streaming" = {
          priority = 3190;
          proxyPass = "http://mastodon-streaming";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Proxy "";

            proxy_buffering off;
            proxy_redirect off;

            add_header Strict-Transport-Security 'max-age=63072000';

            tcp_nodelay on;
          '';
        };

        locations."@mastodon" = {
          priority = 4100;
          proxyPass = "http://mastodon-web";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Proxy "";
            proxy_pass_header Server;

            proxy_buffering on;
            proxy_redirect off;

            proxy_cache ${config.services.nginx.proxyCachePath.mastodon.keysZoneName};
            proxy_cache_valid 200 7d;
            proxy_cache_valid 410 24h;
            proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
            add_header X-Cached $upstream_cache_status;

            tcp_nodelay on;
          '';
        };
      };
    };

    upstreams.mastodon-streaming = {
      extraConfig = ''
        least_conn;
      '';
      servers = builtins.listToAttrs (
        map (i: {
          name = "unix:/run/mastodon-streaming/streaming-${toString i}.socket";
          value.fail_timeout = "0";
        }) (lib.range 1 cfg.streamingProcesses)
      );
    };
    upstreams.mastodon-web = {
      servers."${
        if cfg.enableUnixSocket then
          "unix:/run/mastodon-web/web.socket"
        else
          "127.0.0.1:${toString cfg.webPort}"
      }".fail_timeout =
        "0";
    };
  };
}
