{ config, lib, ... }:

let
  whiteboardServerDomain = "whiteboard.${config.pub-solar-os.networking.domain}";
  whiteboardServerPort = 3002;
in
{
  options.pub-solar-os.nextcloud-whiteboard = {
    enable = lib.mkEnableOption "enable nextcloud-whiteboard-server and required components";
    secretFile = lib.mkOption {
      description = "File containing secrets for whiteboard server. Should be in the format expected by systemd's `EnvironmentFile` directory";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.pub-solar-os.nextcloud-whiteboard.enable {
    services.nginx.virtualHosts."${whiteboardServerDomain}" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString whiteboardServerPort}/";
        proxyWebsockets = true;
      };
    };

    services.nextcloud-whiteboard-server = {
      enable = true;
      settings = {
        NEXTCLOUD_URL = "https://cloud.${config.pub-solar-os.networking.domain}";
        STORAGE_STRATEGY = "lru";
        PORT = "${toString whiteboardServerPort}";
      };
      secrets = [ config.pub-solar-os.nextcloud-whiteboard.secretFile ];
    };
  };
}
