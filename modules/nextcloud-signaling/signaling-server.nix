{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pub-solar-os.nextcloud-signaling;

  port = 8916;

  serverConfig = lib.generators.toINI { } {
    app.trustedproxies = "127.0.0.1";

    backend = {
      backendtype = "static";
      backends = "backend-nextcloud";
    };

    backend-nextcloud = {
      secret = "##NEXTCLOUDSECRET##";
      url = "https://cloud.${config.pub-solar-os.networking.domain}";
    };

    clients.internalsecret = "##INTERNALSECRET##";

    http.listen = "127.0.0.1:${toString port}";

    mcu = {
      type = "janus";
      url = "wss://janus.${config.pub-solar-os.networking.domain}";
    };
    nats.url = "nats://loopback";

    sessions = {
      hashKey = "##HASHKEY##";
      blockKey = "##BLOCKKEY##";
    };

    turn = {
      apikey = "##JANUSAPIKEY##";
      secret = "##TURNSECRET##";
      servers = "turn:turn.${config.pub-solar-os.networking.domain}:${toString config.services.coturn.listening-port}?transport=udp,turn:turn.${config.momo-cloud.networking.domain}:${toString config.services.coturn.listening-port}?transport=tcp";
    };
  };

  serverConfigFile = pkgs.writeText "nextcloud-signaling-server.cfg" serverConfig;

  bootstrapConfig = pkgs.writeShellScript "bootstrap-signaling" ''
    CFG=/etc/nextcloud-signaling-server.cfg

    cp -f ${serverConfigFile} ''${CFG}

    sed -ri "s/##NEXTCLOUDSECRET##/$(cat ${cfg.nextcloudSecretFile})/g" /etc/nextcloud-signaling-server.cfg
    sed -ri "s/##INTERNALSECRET##/$(cat ${cfg.internalSecretFile})/g" /etc/nextcloud-signaling-server.cfg
    sed -ri "s/##HASHKEY##/$(cat ${cfg.hashKeyFile})/g" /etc/nextcloud-signaling-server.cfg
    sed -ri "s/##BLOCKKEY##/$(cat ${cfg.blockKeyFile})/g" /etc/nextcloud-signaling-server.cfg
    sed -ri "s/##JANUSAPIKEY##/$(cat ${cfg.janusApiKeyFile})/g" /etc/nextcloud-signaling-server.cfg
    sed -ri "s/##TURNSECRET##/$(cat ${cfg.turnSecretFile})/g" /etc/nextcloud-signaling-server.cfg
  '';
in
{
  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."signaling.${config.pub-solar-os.networking.domain}" = {
      forceSSL = true;
      enableACME = true;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString port}/";
          proxyWebsockets = true;
        };
      };
    };

    systemd.services.nextcloud-spreed-signaling = {
      serviceConfig = {
        StateDirectory = "nextcloud-spreed-signaling";
        LimitNOFILE = 65536;
        ExecStartPre = "!${bootstrapConfig}";
        ExecStart = "${pkgs.nextcloud-spreed-signaling}/bin/server -config /etc/nextcloud-signaling-server.cfg";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
