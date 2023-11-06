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
        # provide a debian 12 bookworm base for actions
        "debian-latest:docker://debian:bookworm"
        # fake the ubuntu name, commonly used in actions examples
        "ubuntu-latest:docker://debian:bookworm"
        # alpine
        "alpine-latest:docker://alpine:3.18"
        # nix flakes enabled image from
        "nix-flakes:docker://git.pub.solar/pub-solar/nix-flakes-node:latest"
      ];
    };
  };
}
