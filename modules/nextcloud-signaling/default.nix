{ config, lib, ... }:

{
  imports = [
    ./signaling-server.nix
  ];

  options.pub-solar-os.nextcloud-signaling = {
    enable = lib.mkEnableOption "enable nextcloud-signaling-server and required components";
    internalSecretFile = lib.mkOption {
      type = lib.types.str;
    };
    hashKeyFile = lib.mkOption {
      type = lib.types.str;
    };
    blockKeyFile = lib.mkOption {
      type = lib.types.str;
    };
    janusApiKeyFile = lib.mkOption {
      type = lib.types.str;
    };
    turnSecretFile = lib.mkOption {
      type = lib.types.str;
    };
    nextcloudSecretFile = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.pub-solar-os.nextcloud-signaling.enable {
    pub-solar-os.coturn.enable = true;
    pub-solar-os.janus-gw = {
      enable = true;
      apiKeyFile = config.pub-solar-os.nextcloud-signaling.janusApiKeyFile;
    };
  };
}
