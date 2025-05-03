{
  config,
  flake,
  lib,
  ...
}:
{
  imports = [ "${flake.inputs.nixpkgs-draupnir}/nixos/modules/services/matrix/draupnir.nix" ];

  disabledModules = [ "services/matrix/draupnir.nix" ];

  options.pub-solar-os.matrix-draupnir = with lib; {
    enable = mkEnableOption "Enable matrix-draupnir moderation bot";

    homeserver-url = mkOption {
      description = "Matrix homeserver URL";
      type = types.str;
      example = "http://127.0.0.1:8008";
    };

    access-token-file = mkOption {
      description = "Path to access token file";
      type = types.str;
    };
  };

  config = lib.mkIf config.pub-solar-os.matrix-draupnir.enable {

    services.draupnir = {
      enable = true;
      accessTokenFile = config.pub-solar-os.draupnir.access-token-file;
      # https://github.com/the-draupnir-project/Draupnir/blob/main/config/default.yaml
      homeserverUrl = config.pub-solar-os.draupnir.homeserver-url;
      settings = {
        managementRoom = "#moderators:${config.pub-solar-os.networking.domain}";
        protectAllJoinedRooms = true;
      };
    };
  };
}
