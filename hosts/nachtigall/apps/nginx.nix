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
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    appendHttpConfig = ''
      # https://nginx.org/en/docs/hash.html
      proxy_headers_hash_max_size 1024;
    '';
  };
  
  security.acme = {
    acceptTerms = true;
    defaults.email = acmeEmailAddress;
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
