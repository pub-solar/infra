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
    statusPage = true;
    proxyCachePath.cache = {
      enable = true;
    };
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    # see commonHttpConfig
    recommendedTlsSettings = false;
    resolver.addresses = [
      # quad9.net
      "9.9.9.9"
      "149.112.112.112"
      "[2620:fe::fe]"
      "[2620:fe::9]"
    ];
    commonHttpConfig = ''
      # https://my.f5.com/manage/s/article/K51798430
      proxy_headers_hash_bucket_size 128;

      # Add host to access logs
      log_format combined_host '$host - $remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent"';

      # Define our own recommendedTlsSettings without ssl_stapling and with ssl_ecdh_curve
      # Keep in sync with https://ssl-config.mozilla.org/#server=nginx&config=intermediate
      # generated 2025-07-26, Mozilla Guideline v5.7, nginx 1.28.0, OpenSSL 3.4.1, intermediate config, no HSTS, no OCSP
      ssl_ecdh_curve X25519:prime256v1:secp384r1;
      ssl_session_timeout 1d;
      ssl_session_cache shared:SSL:10m;
      # Breaks forward secrecy: https://github.com/mozilla/server-side-tls/issues/135
      ssl_session_tickets off;
      # We don't enable insecure ciphers by default, so this allows
      # clients to pick the most performant, per https://github.com/mozilla/server-side-tls/issues/260
      ssl_prefer_server_ciphers off;
    '';
    appendConfig = ''
      # Number of CPU cores
      worker_processes auto;
    '';
    eventsConfig = ''
      worker_connections 1024;
    '';
  };

  # Only keep last three days of access logs on server
  services.logrotate.settings.nginx = {
    frequency = "daily";
    rotate = 3;
    maxage = 3;
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
