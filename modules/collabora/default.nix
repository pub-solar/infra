{ config
, lib
, pkgs
, self
, ...
}: {
  services.nginx.virtualHosts."collabora.${config.pub-solar-os.networking.domain}" = {
    enableACME = true;
    forceSSL = true;

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
        ports = [
          "127.0.0.1:9980:9980"
        ];
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
