{
  config,
  lib,
  pkgs,
  flake,
  ...
}: {
  age.secrets.forgejo-actions-runner-token = {
    file = "${flake.self}/secrets/forgejo-actions-runner-token.age";
    mode = "644";
  };

  # Trust docker bridge interface traffic
  # Needed for the docker runner to communicate with the act_runner cache
  networking.firewall.trustedInterfaces = [ "br-+" ];

  # forgejo actions runner
  # https://forgejo.org/docs/latest/admin/actions/
  # https://docs.gitea.com/usage/actions/quickstart
  services.gitea-actions-runner = {
    package = pkgs.forgejo-actions-runner;
    instances."flora-6" = {
      enable = true;
      name = config.networking.hostName;
      url = "https://git.pub.solar";
      tokenFile = config.age.secrets.forgejo-actions-runner-token.path;
      labels = [
        # provide a debian 12 bookworm base with Node.js for actions
        "debian-latest:docker://git.pub.solar/pub-solar/actions-base-image:20-bookworm"
        # fake the ubuntu name, commonly used in actions examples
        "ubuntu-latest:docker://git.pub.solar/pub-solar/actions-base-image:20-bookworm"
        # alpine with Node.js
        "alpine-latest:docker://node:20-alpine"
        # nix flakes enabled image with Node.js
        "nix-flakes:docker://git.pub.solar/pub-solar/nix-flakes-node:latest"
      ];
    };
  };
}
