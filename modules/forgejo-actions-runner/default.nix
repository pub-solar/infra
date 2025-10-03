{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gitea-actions-runner;
in
{

  config = lib.mkIf (cfg.instances != { }) {
    # Label configuration on gitea-actions-runner instance requires either docker or podman
    virtualisation.docker = {
      enable = true;
      package = pkgs.docker_28;
      autoPrune.enable = true;
    };

    # Trust docker bridge interface traffic
    # Needed for the docker runner to communicate with the act_runner cache
    networking.firewall.trustedInterfaces = [ "br-+" ];

    users.users.gitea-runner = {
      home = "/var/lib/gitea-runner";
      useDefaultShell = true;
      group = "gitea-runner";
      # Required to interact with nix daemon
      extraGroups = [
        "wheel"
        "docker"
      ];
      isSystemUser = true;
    };

    users.groups.gitea-runner = { };

    systemd.tmpfiles.rules = [
      "d '/var/lib/gitea-runner' 0770 gitea-runner gitea-runner - -"
    ]
    ++ lib.mapAttrsToList (
      name: instance: "d '/var/lib/gitea-runner/${name}' 0770 gitea-runner gitea-runner - -"
    ) cfg.instances;

    systemd.services = lib.concatMapAttrs (name: instance: {
      "gitea-runner-${name}" = {
        serviceConfig.DynamicUser = lib.mkForce false;
        path = with pkgs; [
          coreutils
          openssh
          gnupg
          bash
          curl
          gawk
          gitMinimal
          gnused
          nodejs_22
          wget
          cachix
          jq
          nix
          docker
        ];
      };
    }) cfg.instances;

    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;
    };
  };
}
