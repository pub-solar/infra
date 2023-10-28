{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  acmeEmailAddress = "admins@pub.solar";
  webserverGroup = "hakkonaut";
in {
  services.nginx = {
    enable = true;
    group = webserverGroup;
    enableReload = true;
    proxyCachePath.cache = {
      enable = true;
    };
    recommendedProxySettings = true;
  };
  # Nginx user needs access to mastodon unix sockets
  users.users.nginx.extraGroups = [ "mastodon" ];
  
  security.acme = {
    acceptTerms = true;
    defaults.email = acmeEmailAddress;
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
