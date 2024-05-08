{ config, flake, ... }:
{
  imports = [ "${flake.inputs.nixpkgs-draupnir}/nixos/modules/services/matrix/draupnir.nix" ];

  disabledModules = [ "services/matrix/draupnir.nix" ];

  age.secrets."matrix-draupnir-access-token" = {
    file = "${flake.self}/secrets/matrix-draupnir-access-token.age";
    mode = "640";
    owner = "root";
    group = "draupnir";
  };

  services.draupnir = {
    enable = true;
    accessTokenFile = config.age.secrets.matrix-draupnir-access-token.path;
    # https://github.com/the-draupnir-project/Draupnir/blob/main/config/default.yaml
    settings = {
      homeserverUrl = "http://localhost:8008";
      managementRoom = "#moderators:pub.solar";
      protectAllJoinedRooms = true;
    };
  };
}
