{ flake, config, ... }:
let
  vHostDomain = "mollysocket.${config.pub-solar-os.networking.domain}";
in
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

  services.nginx.virtualHosts.${vHostDomain} = {
    forceSSL = true;
    enableACME = true;

    extraConfig = ''
      access_log /var/log/nginx/${vHostDomain}-access.log combined_host;
      error_log /var/log/nginx/${vHostDomain}-error.log;
    '';

    locations."/" = {
      proxyPass = "http://127.0.0.1:8020/";
      extraConfig = ''
        proxy_set_header            Host $host;
        proxy_set_header X-Original-URL $request_uri;
      '';
    };
  };
}
