{ config, flake, lib, ... }:
let
  # Find element in list config.services.matrix-synapse.settings.listeners
  # that sets type = "metrics"
  listenerWithMetrics = lib.findFirst
    (listener:
      listener.type == "metrics")
    (throw "Found no matrix-synapse.settings.listeners.*.type containing string metrics")
    config.services.matrix-synapse.settings.listeners
  ;
  synapseMetricsPort = "${toString listenerWithMetrics.port}";
in
{
  age.secrets.nachtigall-metrics-nginx-basic-auth = {
    file = "${flake.self}/secrets/nachtigall-metrics-nginx-basic-auth.age";
    mode = "600";
    owner = "nginx";
  };
  services.nginx.virtualHosts = {
    "nachtigall.${config.pub-solar-os.networking.domain}" = {
      enableACME = true;
      addSSL = true;
      basicAuthFile = "${config.age.secrets.nachtigall-metrics-nginx-basic-auth.path}";
      locations."/metrics" = {
        proxyPass = "http://127.0.0.1:${toString(config.services.prometheus.exporters.node.port)}";
      };
      locations."/_synapse/metrics" = {
        proxyPass = "http://127.0.0.1:${synapseMetricsPort}";
      };
    };
  };
}
