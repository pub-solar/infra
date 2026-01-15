{
  config,
  flake,
  ...
}:
{
  age.secrets."forgejo-actions-runner-token-miom" = {
    file = "${flake.self}/secrets/trinkgenossin-forgejo-actions-runner-token-miom.age";
    owner = "gitea-runner";
    mode = "440";
  };
  age.secrets."forgejo-actions-runner-token-momo" = {
    file = "${flake.self}/secrets/trinkgenossin-forgejo-actions-runner-token-momo.age";
    owner = "gitea-runner";
    mode = "440";
  };
  age.secrets."forgejo-actions-runner-token-pub-solar" = {
    file = "${flake.self}/secrets/trinkgenossin-forgejo-actions-runner-token.age";
    owner = "gitea-runner";
    mode = "440";
  };

  # forgejo actions runner
  # https://forgejo.org/docs/latest/admin/actions/
  # https://docs.gitea.com/usage/actions/quickstart
  services.gitea-actions-runner.instances = {
    miom = {
      enable = true;
      url = "https://git.pub.solar";
      name = config.networking.hostName;
      tokenFile = config.age.secrets.forgejo-actions-runner-token-miom.path;
      labels = [
        # provide a debian 13 trixie base with Node.js for actions
        "debian-latest:docker://git.pub.solar/pub-solar/actions-base-image:24-trixie"
        # fake the ubuntu name, commonly used in actions examples
        "ubuntu-latest:docker://git.pub.solar/pub-solar/actions-base-image:24-trixie"
        # alpine with Node.js
        "alpine-latest:docker://node:24-alpine"
      ];
      # Required to avoid docker-in-docker and still be able to build docker images
      # and for actions that use RUNNER_TOOL_CACHE
      settings = {
        container = {
          docker_host = "unix:///var/run/docker.sock";
          options = "-v act-toolcache:/opt/hostedtoolcache";
          valid_volumes = [
            "act-toolcache"
          ];
        };
      };
    };
    momo = {
      enable = true;
      url = "https://git.pub.solar";
      name = config.networking.hostName;
      tokenFile = config.age.secrets.forgejo-actions-runner-token-momo.path;
      labels = [
        "self-hosted:host"

        # provide a debian 13 trixie base with Node.js for actions
        "debian-latest:docker://git.pub.solar/pub-solar/actions-base-image:24-trixie"
        # fake the ubuntu name, commonly used in actions examples
        "ubuntu-latest:docker://git.pub.solar/pub-solar/actions-base-image:24-trixie"
        # alpine with Node.js
        "alpine-latest:docker://node:24-alpine"
      ];
      # Required to avoid docker-in-docker and still be able to build docker images
      # and for actions that use RUNNER_TOOL_CACHE
      settings = {
        container = {
          docker_host = "unix:///var/run/docker.sock";
          options = "-v act-toolcache:/opt/hostedtoolcache";
          valid_volumes = [
            "act-toolcache"
          ];
        };
      };
    };
    # systemd does not like dashes in service unit names
    pubsolar = {
      enable = true;
      url = "https://git.pub.solar";
      name = config.networking.hostName;
      tokenFile = config.age.secrets.forgejo-actions-runner-token-pub-solar.path;
      labels = [
        # provide a debian 13 trixie base with Node.js for actions
        "debian-latest:docker://git.pub.solar/pub-solar/actions-base-image:24-trixie"
        # fake the ubuntu name, commonly used in actions examples
        "ubuntu-latest:docker://git.pub.solar/pub-solar/actions-base-image:24-trixie"
        # alpine with Node.js
        "alpine-latest:docker://node:24-alpine"
      ];
      # Required to avoid docker-in-docker and still be able to build docker images
      # and for actions that use RUNNER_TOOL_CACHE
      settings = {
        container = {
          docker_host = "unix:///var/run/docker.sock";
          options = "-v act-toolcache:/opt/hostedtoolcache";
          valid_volumes = [
            "act-toolcache"
          ];
        };
      };
    };
  };
}
