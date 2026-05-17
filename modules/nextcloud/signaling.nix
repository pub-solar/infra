{
  config,
  lib,
  ...
}:

let
  cfg = config.pub-solar-os.nextcloud-signaling;
  vHostDomain = "signaling.${config.pub-solar-os.networking.domain}";
  port = 8916;
in
{
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

  config = lib.mkIf cfg.enable {
    pub-solar-os.janus-gw = {
      enable = true;
      apiKeyFile = config.pub-solar-os.nextcloud-signaling.janusApiKeyFile;
    };

    services.nginx.virtualHosts."${vHostDomain}" = {
      enableACME = true;
      forceSSL = true;

      extraConfig = ''
        access_log /var/log/nginx/${vHostDomain}-access.log combined_host;
        error_log /var/log/nginx/${vHostDomain}-error.log;
      '';
    };

    services.nextcloud-spreed-signaling = {
      enable = true;

      configureNginx = true;
      hostName = vHostDomain;

      backends.nextcloud = {
        urls = [ "https://cloud.${config.pub-solar-os.networking.domain}" ];
        secretFile = "${cfg.nextcloudSecretFile}";
      };
      settings = {
        clients = {
          internalsecretFile = "${cfg.internalSecretFile}";
        };
        sessions = {
          hashkeyFile = "${cfg.hashKeyFile}";
          blockkeyFile = "${cfg.blockKeyFile}";
        };
        http = {
          listen = "127.0.0.1:${toString port}";
        };
        mcu = {
          type = "janus";
          url = "wss://janus.${config.pub-solar-os.networking.domain}";
        };
        turn = {
          servers = [
            "turn:turn.${config.pub-solar-os.networking.domain}:${toString config.services.coturn.listening-port}?transport=udp,turn:turn.${config.pub-solar-os.networking.domain}:${toString config.services.coturn.listening-port}?transport=tcp"
          ];
          apikeyFile = "${cfg.janusApiKeyFile}";
          secretFile = "${cfg.turnSecretFile}";
        };
      };
    };
  };
}
