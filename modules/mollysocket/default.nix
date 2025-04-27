{ flake, config, ... }:
{
  age.secrets."mollysocket-env" = {
    file = "${flake.self}/secrets/mollysocket-env.age";
    mode = "400";
    owner = "root";
  };

  services.mollysocket = {
    enable = true;
    settings = {
      allowed_uuids = [ "*" ];
      allowed_endpoints = [ "https://cloud.${config.pub-solar-os.networking.domain}" ];
    };
    environmentFile = config.age.secrets."mollysocket-env".path;
  };

  services.nginx.virtualHosts."mollysocket.${config.pub-solar-os.networking.domain}" = {
    forceSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:8020/";
      extraConfig = ''
        proxy_set_header            Host $host;
        proxy_set_header X-Original-URL $request_uri;
      '';
    };
  };
}
