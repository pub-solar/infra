{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  acmeEmailAddress = config.pub-solar-os.adminEmail;
  webserverGroup = "hakkonaut";
in
{
  users.users.nginx.extraGroups = [ webserverGroup ];

  services.nginx = {
    enable = true;
    enableReload = true;
    proxyCachePath.cache = {
      enable = true;
    };
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    resolver.addresses = [
      # quad9.net
      "9.9.9.9"
      "149.112.112.112"
      "[2620:fe::fe]"
      "[2620:fe::9]"
    ];
    appendHttpConfig = ''
      # https://my.f5.com/manage/s/article/K51798430
      proxy_headers_hash_bucket_size 128;
    '';
    appendConfig = ''
      # Number of CPU cores
      worker_processes 8;
    '';
    eventsConfig = ''
      worker_connections 1024;
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = acmeEmailAddress;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
