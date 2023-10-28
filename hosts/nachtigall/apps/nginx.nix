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
  };
  
  security.acme = {
    acceptTerms = true;
    defaults.email = acmeEmailAddress;
  };

  networking.firewall.allowedTCPPorts = [80 443];

  systemd.tmpfiles.rules = [
    "d '/srv/www/pub.solar' 0750 hakkonaut hakkonaut - -"
  ];
}
