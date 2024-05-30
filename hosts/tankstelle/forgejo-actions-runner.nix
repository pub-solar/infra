{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  age.secrets.tankstelle-forgejo-actions-runner-token = {
    file = "${flake.self}/secrets/tankstelle-forgejo-actions-runner-token.age";
    mode = "440";
  };

  # Trust docker bridge interface traffic
  # Needed for the docker runner to communicate with the act_runner cache
  networking.firewall.trustedInterfaces = [ "br-+" ];

  users.users.gitea-runner = {
    home = "/var/lib/gitea-runner/tankstelle";
    useDefaultShell = true;
    group = "gitea-runner";
    # Required to interact with nix daemon
    extraGroups = [
     "wheel"
    ];
    isSystemUser = true;
  };

  users.groups.gitea-runner = { };

  systemd.tmpfiles.rules = [ "d '/var/lib/gitea-runner' 0750 gitea-runner gitea-runner - -" ];

  systemd.services."gitea-runner-tankstelle" = {
    serviceConfig.DynamicUser = lib.mkForce false;
    path = with pkgs; [
      coreutils
      bash
      coreutils
      curl
      gawk
      gitMinimal
      gnused
      nodejs
      wget
      cachix
      jq
    ];
  };

  # forgejo actions runner
  # https://forgejo.org/docs/latest/admin/actions/
  # https://docs.gitea.com/usage/actions/quickstart
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances."tankstelle" = {
      enable = true;
      name = config.networking.hostName;
      url = "https://git.pub.solar";
      tokenFile = config.age.secrets.tankstelle-forgejo-actions-runner-token.path;
      labels = [ "self-hosted:host://-self-hosted" ];
    };
  };
}
