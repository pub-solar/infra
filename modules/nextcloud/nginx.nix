{
  config,
  pkgs,
  flake,
  lib,
  ...
}:
{
  services.nginx.virtualHosts."cloud.${config.pub-solar-os.networking.domain}" = {
    enableACME = true;
    forceSSL = true;

    locations = {
      "=/_matrix/push/v1/notify" = {
        extraConfig = ''
          set $custom_request_uri /index.php/apps/uppush/gateway/matrix;
          rewrite ^.*$ /index.php/apps/uppush/gateway/matrix last;
        '';
      };

      # Increase timeouts for unified push
      "^~ /index.php/apps/uppush/" = {
        priority = 499;
        extraConfig = ''
          # this is copy-pasted from nixpkgs
          include ${config.services.nginx.package}/conf/fastcgi.conf;
          fastcgi_split_path_info ^(.+?\.php)(/.*)$;
          set $path_info $fastcgi_path_info;
          try_files $fastcgi_script_name =404;
          fastcgi_param PATH_INFO $path_info;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_param HTTPS ${if config.services.nextcloud.https then "on" else "off"};
          fastcgi_param modHeadersAvailable true;
          fastcgi_param front_controller_active true;

          # Added timeouts for nextpush
          fastcgi_buffering off;
          fastcgi_connect_timeout 10m;
          fastcgi_send_timeout 10m;
          fastcgi_read_timeout 10m;

          # If custom request is not set (ergo not _matrix push) then just keep request_uri
          if ($custom_request_uri ~ "^$") {
              set $custom_request_uri $request_uri;
          }
          # Apply our custom uri
          fastcgi_param REQUEST_URI $custom_request_uri;

          # copied from nixpkgs again
          fastcgi_pass unix:${config.services.phpfpm.pools.nextcloud.socket};
          fastcgi_intercept_errors on;
          fastcgi_request_buffering off;
        '';
      };
    };
  };
}
