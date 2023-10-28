{ ... }:

let
  objStorHost = "link.tardigradeshare.io";
  objStorBucket = "s/jw24ad6l4a6zxsnd32cmf5hp5nsq/pub-solar-mastodon";
in
{
  services.nginx.virtualHosts = {
    "files.pub.solar" = {
      enableACME = true;
      forceSSL = true;

      locations = {
        "= /" = {
          index = "index.html";
        };

        "/" = {
          tryFiles = "$uri @s3";
        };

        "@s3" = {
          extraConfig = ''
            limit_except GET {
              deny all;
            }

            resolver 8.8.8.8;
            proxy_set_header Host $host;
            proxy_set_header Connection \'\';
            proxy_set_header Authorization \'\';
            proxy_hide_header Set-Cookie;
            proxy_hide_header 'Access-Control-Allow-Origin';
            proxy_hide_header 'Access-Control-Allow-Methods';
            proxy_hide_header 'Access-Control-Allow-Headers';
            proxy_hide_header x-amz-id-2;
            proxy_hide_header x-amz-request-id;
            proxy_hide_header x-amz-meta-server-side-encryption;
            proxy_hide_header x-amz-server-side-encryption;
            proxy_hide_header x-amz-bucket-region;
            proxy_hide_header x-amzn-requestid;
            proxy_ignore_headers Set-Cookie;
            proxy_pass https://${objStorHost}/${objStorBucket}$request_uri?download;
            proxy_intercept_errors off;

            proxy_cache cache;
            proxy_cache_valid 200 48h;
            proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
            proxy_cache_lock on;

            expires 1y;
            add_header Cache-Control public;
            add_header 'Access-Control-Allow-Origin' '*';
            add_header X-Cache-Status $upstream_cache_status;
            add_header X-Content-Type-Options nosniff;
            add_header Content-Security-Policy "default-src 'none'; form-action 'none'";
          '';
        };
      };
    };
  };
}
