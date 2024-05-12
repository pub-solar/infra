{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  age.secrets.forgejo-actions-runner-token = {
    file = "${flake.self}/secrets/forgejo-actions-runner-token.age";
    mode = "440";
  };

  # Trust docker bridge interface traffic
  # Needed for the docker runner to communicate with the act_runner cache
  networking.firewall.trustedInterfaces = [ "br-+" ];

  users.users.gitea-runner = {
    home = "/var/lib/gitea-runner/flora-6";
    useDefaultShell = true;
    group = "gitea-runner";
    isSystemUser = true;
  };

  users.groups.gitea-runner = { };

  systemd.services."gitea-runner-flora\\x2d6".serviceConfig = {
    DynamicUser = lib.mkForce false;
  };

  systemd.tmpfiles.rules = [
    "d '/data/gitea-actions-runner' 0750 gitea-runner gitea-runner - -"
    "d '/var/lib/gitea-runner' 0750 gitea-runner gitea-runner - -"
  ];

  # forgejo actions runner
  # https://forgejo.org/docs/latest/admin/actions/
  # https://docs.gitea.com/usage/actions/quickstart
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances."flora-6" = {
      enable = true;
      name = config.networking.hostName;
      url = "https://git.pub.solar";
      tokenFile = config.age.secrets.forgejo-actions-runner-token.path;
      settings = {
        cache = {
          enabled = true;
          dir = "/data/gitea-actions-runner/actcache";
          host = "";
          port = 0;
          external_server = "";
        };
      };
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
