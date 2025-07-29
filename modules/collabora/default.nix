{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  vHostDomain = "collabora.${config.pub-solar-os.networking.domain}";
in
{
  services.nginx.virtualHosts."${vHostDomain}" = {
    enableACME = true;
    forceSSL = true;

    extraConfig = ''
      access_log /var/log/nginx/${vHostDomain}-access.log combined_host;
      error_log /var/log/nginx/${vHostDomain}-error.log;
    '';

    locations."/" = {
      proxyWebsockets = true;
      extraConfig = ''
        proxy_pass http://127.0.0.1:9980;
        proxy_set_header Host $host;
      '';
    };
  };

  virtualisation = {
    oci-containers = {
      backend = "docker";

      containers."collabora" = {
        image = "collabora/code";
        autoStart = true;
        ports = [ "127.0.0.1:9980:9980" ];
        extraOptions = [
          "--cap-add=MKNOD"
          "--pull=always"
        ];
        environment = {
          server_name = "collabora.${config.pub-solar-os.networking.domain}";
          aliasgroup1 = "https://cloud.${config.pub-solar-os.networking.domain}:443";
          DONT_GEN_SSL_CERT = "1";
          extra_params = "--o:ssl.enable=false --o:ssl.termination=true";
          SLEEPFORDEBUGGER = "0";
        };
      };
    };
  };
}
