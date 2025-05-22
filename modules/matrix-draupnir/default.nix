{
  config,
  flake,
  lib,
  ...
}:
{
  imports = [ "${flake.inputs.nixpkgs-draupnir}/nixos/modules/services/matrix/draupnir.nix" ];

  disabledModules = [ "services/matrix/draupnir.nix" ];

  options.pub-solar-os.matrix.draupnir = with lib; {
    enable = mkEnableOption "Enable Matrix draupnir moderation bot";

    homeserver-url = mkOption {
      description = "Matrix homeserver URL";
      type = types.str;
      example = "http://127.0.0.1:8008";
    };

    raw-homeserver-url = mkOption {
      description = "Matrix homeserver URL, used to fetch events related to reports";
      type = types.str;
      example = "http://127.0.0.1:8008";
      default = config.pub-solar-os.matrix.draupnir.homeserver-url;
    };

    access-token-file = mkOption {
      description = "Path to access token file";
      type = types.str;
    };

    http-antispam-authorization-file = mkOption {
      description = "Path to synapse-http-antispam authorization file";
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = lib.mkIf config.pub-solar-os.matrix.draupnir.enable {

    services.draupnir = {
      enable = true;
      accessTokenFile = config.pub-solar-os.matrix.draupnir.access-token-file;
      httpAntispamAuthorizationFile =
        config.pub-solar-os.matrix.draupnir.http-antispam-authorization-file;
      # https://github.com/the-draupnir-project/Draupnir/blob/main/config/default.yaml
      homeserverUrl = config.pub-solar-os.matrix.draupnir.homeserver-url;
      settings = {
        rawHomeserverUrl = config.pub-solar-os.matrix.draupnir.raw-homeserver-url;
        managementRoom = "#matrix-moderators:${config.pub-solar-os.networking.domain}";
        protectAllJoinedRooms = true;
        recordIgnoredInvites = true;
        automaticallyRedactForReasons = [
          "*spam"
          "advertising"
        ];
        web = {
          enabled = true;
          port = 8080;
          address = "127.0.200.101";
          abuseReporting.enabled = true;
          synapseHTTPAntispam = {
            enabled =
              if config.pub-solar-os.matrix.draupnir.http-antispam-authorization-file != null then
                true
              else
                false;
          };
        };
      };
    };
  };
}
