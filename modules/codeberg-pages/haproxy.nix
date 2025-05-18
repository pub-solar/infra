{
  config,
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
        bind :::443 v4v6
        mode tcp

        # Wait up to 5s for a SNI header & only accept TLS connections
        tcp-request inspect-delay 5s
        tcp-request content capture req.ssl_sni len 255
        log-format "%ci:%cp -> %[capture.req.hdr(0)] @ %f (%fi:%fp) -> %b (%bi:%bp)"
        tcp-request content accept if { req.ssl_hello_type 1 }

        # forwarding to backends based on SNI
        # use nginx_backend for all SNI matching domain, for example *.pub.solar
        # else use pages_backend
        acl use_nginx_backend req.ssl_sni -i -m end .${config.pub-solar-os.networking.domain}
        acl use_pages_backend req.ssl_sni -m reg ..*

        use_backend pages_backend if use_pages_backend !use_nginx_backend
        default_backend nginx_backend

      backend http_backend
        # pages-server redirects http -> https
        # uses HTTP-01 challenges to get certificates for custom domains
        server pages_server_http ${config.pub-solar-os.codeberg-pages.host}:${config.pub-solar-os.codeberg-pages.http-port}
        mode tcp

      backend pages_backend
        # Pages server is a TCP backend that uses its own certificates for custom domains
        server pages_server ${config.pub-solar-os.codeberg-pages.host}:${config.pub-solar-os.codeberg-pages.port} send-proxy
        mode tcp

      backend nginx_backend
        server nginx_server 127.0.0.1:${toString config.services.nginx.defaultSSLListenPort} send-proxy
        mode tcp
    '';
  };
}
