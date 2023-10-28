{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  services.nginx.virtualHosts."collabora.pub.solar" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://localhost:9980";
  };

  virtualisation = {
    oci-containers = {
      backend = "docker";

      containers."collabora" = {
        image = "collabora/code";
        autoStart = true;
        ports = [
          "9980:9980"
        ];
        extraOptions = [
          "--cap-add=MKNOD"
          "--pull=always"
        ];
        environment = {
          server_name = "collabora.pub.solar";
          aliasgroup1 = "https://cloud.pub.solar:443";
          DONT_GEN_SSL_CERT = "1";
          extra_params = "--o:ssl.enable=false --o:ssl.termination=true";
          SLEEPFORDEBUGGER = "0";
        };
      };
    };
  };
}
