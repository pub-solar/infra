{ ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./configuration.nix
      ./triton-vmtools.nix

      ./apps/caddy.nix

      ./apps/drone.nix
      ./apps/forgejo-actions-runner.nix
      ./apps/grafana.nix
      ./apps/prometheus.nix
      ./apps/loki.nix
    ];
}
