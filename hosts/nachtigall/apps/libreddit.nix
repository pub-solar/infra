{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  services.nginx.virtualHosts."libreddit.pub.solar" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyWebsockets = true;
      extraConfig = ''
        proxy_pass http://127.0.0.1:8082;
        proxy_set_header Host $host;
      '';
      };
  };

  services.libreddit = {
    enable = true;
    openFirewall = false;
    address = "127.0.0.1";
    port = "8082";
  };
}
