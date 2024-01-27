{ config, lib, ... }:
let
  cfg = config.services.mastodon;
in
{
  services.nginx = {
    virtualHosts = {
      "mastodon.pub.solar" = {
        root = "${cfg.package}/public/";
        # mastodon only supports https, but you can override this if you offload tls elsewhere.
        forceSSL = lib.mkDefault true;
        enableACME = lib.mkDefault true;

        locations."/auth/sign_up".extraConfig = ''
          return 302 /auth/sign_in;
        '';

        locations."/auth/confirmation/new".extraConfig = ''
          return 302 https://auth.pub.solar/realms/pub.solar/login-actions/reset-credentials?client_id=mastodon;
        '';

        locations."/auth/password/new".extraConfig = ''
          return 302 https://auth.pub.solar/realms/pub.solar/login-actions/reset-credentials?client_id=mastodon;
        '';

        locations."/system/".alias = "/var/lib/mastodon/public-system/";

        locations."/" = {
          tryFiles = "$uri @proxy";
        };

        locations."@proxy" = {
          proxyPass = (if cfg.enableUnixSocket then "http://unix:/run/mastodon-web/web.socket" else "http://127.0.0.1:${toString(cfg.webPort)}");
          proxyWebsockets = true;
        };

        locations."/api/v1/streaming/" = {
          proxyPass = "http://mastodon-streaming";
          proxyWebsockets = true;
        };
      };
    };

    upstreams.mastodon-streaming = {
      extraConfig = ''
        least_conn;
      '';
      servers = builtins.listToAttrs
        (map
          (i: {
            name = "unix:/run/mastodon-streaming/streaming-${toString i}.socket";
            value = { };
          })
          (lib.range 1 cfg.streamingProcesses));
    };
  };
}
