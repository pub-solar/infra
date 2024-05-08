{ flake
, config
, lib
, pkgs
, ...
}: {
  services.nginx.virtualHosts."stream.${config.pub-solar-os.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5000";
      proxyWebsockets = true;
    };
  };

  # Owncast
  services.owncast = {
    enable = true;
    user = "owncast";
    group = "owncast";
    # The directory where owncast stores its data files.
    dataDir = "/var/lib/owncast";
    # Open the appropriate ports in the firewall for owncast.
    openFirewall = true;
    # The IP address to bind the owncast web server to.
    listen = "127.0.0.1";
    # TCP port where owncast rtmp service listens.
    rtmp-port = 1935;
    # TCP port where owncast web-gui listens.
    port = 5000;
  };
}
