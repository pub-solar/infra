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
      labels = [
        "self-hosted:host://-self-hosted"
      ];
    };
  };
}
