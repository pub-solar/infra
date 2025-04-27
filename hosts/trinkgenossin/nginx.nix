{
  config,
  pkgs,
  flake,
  ...
}:
{
  # Change nginx default ports to allow haproxy tcp forwarding,
  # mainly to allow usage of codeberg-pages with custom domains
  services.nginx = {
    defaultHTTPListenPort = 8080;
    defaultSSLListenPort = 8443;

    virtualHosts."buckets.${config.pub-solar-os.networking.domain}".listen = [
      {
        addr = "127.0.0.1";
        port = 8443;
        proxyProtocol = true;
        ssl = true;
      }
    ];

    virtualHosts."web.${config.pub-solar-os.networking.domain}".listen = [
      {
        addr = "127.0.0.1";
        port = 8443;
        proxyProtocol = true;
        ssl = true;
      }
    ];
  };
}
