{ lib, flake, ... }:
{
  age.secrets."matrix-mjolnir-password" = {
    file = "${flake.self}/secrets/matrix-mjolnir-password.age";
    mode = "640";
    owner = "root";
    group = "mjolnir";
  };

  # Adopted from:
  # https://github.com/NixOS/nixos-org-configurations/blob/42ab3d94c0b5995f2ea05eb0b20b4759192c01ff/non-critical-infra/modules/mjolnir.nix
  #
  # pantalaimon takes ages to start up, so mjolnir could hit the systemd burst
  # limit and then just be down forever. We don't want mjolnir to ever go down,
  # so disable rate-limiting and allow it to flap until pantalaimon is alive.
  systemd.services.mjolnir.serviceConfig.Restart = lib.mkForce "always";
  systemd.services.mjolnir.serviceConfig.RestartSec = 3;
  systemd.services.mjolnir.unitConfig.StartLimitIntervalSec = 0;

  services.pantalaimon-headless.instances.mjolnir.listenAddress = "127.0.0.1";

  services.mjolnir = {
    enable = true;
    homeserverUrl = "https://matrix.pub.solar:443";

    pantalaimon = {
      enable = true;
      username = "mjolnir";
      passwordFile = "/run/agenix/matrix-mjolnir-password";
      options = {
        listenAddress = "127.0.0.1";
      };
    };

    managementRoom = "#moderators:pub.solar";

    # https://github.com/matrix-org/mjolnir/blob/master/config/default.yaml
    settings = {
      noop = false;
      protectAllJoinedRooms = true;
      fasterMembershipChecks = true;

      # too noisy
      verboseLogging = false;
    };
  };
}
