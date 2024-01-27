{ config, flake, lib, ... }:
let
  # Get port from first element in list of matrix-synapse listeners
  synapsePort = "${toString (lib.findFirst (listener: listener.port != null) "" config.services.matrix-synapse.settings.listeners).port}";
in
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
        proxyPass = "http://127.0.0.1:${synapsePort}";
      };
    };
  };
}
