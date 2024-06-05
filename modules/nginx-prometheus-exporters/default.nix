{
  config,
  flake,
  lib,
  ...
}:
let
  # Find element in list config.services.matrix-synapse.settings.listeners
  # that sets type = "metrics"
  listenerWithMetrics =
    lib.findFirst (listener: listener.type == "metrics")
      (throw "Found no matrix-synapse.settings.listeners.*.type containing string metrics")
      config.services.matrix-synapse.settings.listeners;
  synapseMetricsPort = "${toString listenerWithMetrics.port}";
in
{
  services.nginx.virtualHosts = {
    "nachtigall.wg.${config.pub-solar-os.networking.domain}" = {
      listenAddresses = [
        "10.7.6.1"
        "[fd00:fae:fae:fae:fae:1::]"
      ];
      locations."/metrics" = {
        proxyPass = "http://127.0.0.1:${toString (config.services.prometheus.exporters.node.port)}";
      };
      locations."/_synapse/metrics" = {
        proxyPass = "http://127.0.0.1:${synapseMetricsPort}";
      };
    };
  };
}
