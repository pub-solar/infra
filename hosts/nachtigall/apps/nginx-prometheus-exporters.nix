{ config, flake, ... }:

{
  age.secrets.nachtigall-metrics-nginx-basic-auth = {
    file = "${flake.self}/secrets/nachtigall-metrics-nginx-basic-auth.age";
    mode = "600";
    owner = "nginx";
  };
  services.nginx.virtualHosts = {
    "nachtigall.pub.solar" = {
      enableACME = true;
      addSSL = true;
      basicAuthFile = "${config.age.secrets.nachtigall-metrics-nginx-basic-auth.path}";
      locations."/metrics" = {
        proxyPass = "http://127.0.0.1:${toString(config.services.prometheus.exporters.node.port)}";
      };
      locations."/_synapse/metrics" = {
        proxyPass = "http://127.0.0.1:${toString (builtins.map (listener: listener.port) config.services.matrix-synapse.settings.listeners)}";
      };
    };
  };
}
