{
  config,
  pkgs,
  lib,
  flake,
  ...
}:
let
  hostname = config.networking.hostName;
in
{
  age.secrets."forgejo-actions-runner-token.age" = {
    file = "${flake.self}/secrets/trinkgenossin-forgejo-actions-runner-token.age";
    owner = "gitea-runner";
    mode = "440";
  };

  # Label configuration on gitea-actions-runner instance requires either docker or podman
  virtualisation.docker.enable = true;

  # Trust docker bridge interface traffic
  # Needed for the docker runner to communicate with the act_runner cache
  networking.firewall.trustedInterfaces = [ "br-+" ];

  users.users.gitea-runner = {
    home = "/var/lib/gitea-runner/${hostname}";
    useDefaultShell = true;
    group = "gitea-runner";
    # Required to interact with nix daemon
    extraGroups = [ "wheel" ];
    isSystemUser = true;
  };

  users.groups.gitea-runner = { };

  systemd.tmpfiles.rules = [ "d '/var/lib/gitea-runner' 0750 gitea-runner gitea-runner - -" ];

  systemd.services."gitea-runner-${hostname}" = {
    serviceConfig.DynamicUser = lib.mkForce false;
  };

  # forgejo actions runner
  # https://forgejo.org/docs/latest/admin/actions/
  # https://docs.gitea.com/usage/actions/quickstart
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances."${hostname}" = {
      enable = true;
      name = hostname;
      url = "https://git.pub.solar";
      tokenFile = config.age.secrets."forgejo-actions-runner-token.age".path;
      labels = [
        # provide a debian 12 bookworm base with Node.js for actions
        "debian-latest:docker://git.pub.solar/pub-solar/actions-base-image:20-bookworm"
        # fake the ubuntu name, commonly used in actions examples
        "ubuntu-latest:docker://git.pub.solar/pub-solar/actions-base-image:20-bookworm"
        # alpine with Node.js
        "alpine-latest:docker://node:20-alpine"
      ];
    };
  };
}
