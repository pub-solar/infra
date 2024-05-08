{ ... }:

{
  systemd.tmpfiles.rules = [ "d '/srv/www/miom.space' 0750 hakkonaut hakkonaut - -" ];

  services.nginx.virtualHosts = {
    "www.miom.space" = {
      enableACME = true;
      addSSL = true;

      extraConfig = ''
        error_log /dev/null;
        access_log /dev/null;
      '';

      locations."/" = {
        extraConfig = ''
          return 301 https://miom.space$request_uri;
        '';
      };
    };

    "miom.space" = {
      enableACME = true;
      forceSSL = true;

      extraConfig = ''
        error_log /dev/null;
        access_log /dev/null;
      '';

      locations = {
        "/" = {
          root = "/srv/www/miom.space";
          index = "index.html";
          tryFiles = "$uri $uri/ =404";
        };
      };
    };
  };
}
