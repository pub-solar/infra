{
  config,
  flake,
  ...
}:
{
  age.secrets.tankstelle-forgejo-actions-runner-token = {
    file = "${flake.self}/secrets/tankstelle-forgejo-actions-runner-token.age";
    mode = "440";
  };
  age.secrets.tankstellezwei-forgejo-actions-runner-token = {
    file = "${flake.self}/secrets/tankstellezwei-forgejo-actions-runner-token.age";
    mode = "440";
  };

  # forgejo actions runner
  # https://forgejo.org/docs/latest/admin/actions/
  # https://docs.gitea.com/usage/actions/quickstart
  services.gitea-actions-runner.instances = {
    tankstelle = {
      enable = true;
      url = "https://git.pub.solar";
      name = config.networking.hostName;
      tokenFile = config.age.secrets.tankstelle-forgejo-actions-runner-token.path;
      labels = [
        "self-hosted:host://-self-hosted"
      ];
    };
    tankstellezwei = {
      enable = true;
      url = "https://git.pub.solar";
      name = "tankstellezwei";
      tokenFile = config.age.secrets.tankstellezwei-forgejo-actions-runner-token.path;
      labels = [
        "self-hosted:host://-self-hosted"
      ];
    };
  };
}
