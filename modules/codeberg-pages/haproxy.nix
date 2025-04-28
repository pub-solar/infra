{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  services.haproxy = {
    enable = true;
    config = ''
      #####################################
      ## Global Configuration & Defaults ##
      #####################################

      global
        log stderr format iso local7

      defaults
        log global
        timeout connect 30000
        timeout check 300000
        timeout client 300000
        timeout server 300000

      frontend http_frontend
        bind :::80 v4v6
        mode tcp
        default_backend http_backend

      frontend https_sni_frontend
        # TCP backend to forward to HTTPS backends based on SNI
        bind :::443 v4v6
        mode tcp

        # Wait up to 5s for a SNI header & only accept TLS connections
        tcp-request inspect-delay 5s
        tcp-request content capture req.ssl_sni len 255
        log-format "%ci:%cp -> %[capture.req.hdr(0)] @ %f (%fi:%fp) -> %b (%bi:%bp)"
        tcp-request content accept if { req.ssl_hello_type 1 }

        acl use_nginx_backend req.ssl_sni -i -m reg ^.*\\.pub\\.solar$
        acl use_pages_backend req.ssl_sni -m reg ..*

        use_backend pages_backend if use_pages_backend !use_nginx_backend
        default_backend nginx_backend

      backend http_backend
        server pages_server_http 127.0.0.1:8081
        mode tcp

      backend pages_backend
        # Pages server is a HTTP backend that uses its own certificates for custom domains
        server pages_server 127.0.0.1:3443 send-proxy
        mode tcp

      backend nginx_backend
        server nginx_server 127.0.0.1:8443 send-proxy
        mode tcp
    '';
  };
}
