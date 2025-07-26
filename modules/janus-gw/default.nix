{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.pub-solar-os.janus-gw;
  domain = "janus.${config.pub-solar-os.networking.domain}";
  httpPort = "8088";
  wsPort = "8188";

  janusCfg = pkgs.writeText "janus.jcfg" ''
    plugins: {
      disable = "libjanus_audiobridge.so,libjanus_echotest.so,libjanus_nosip.so,libjanus_recordplay.so,libjanus_sip.so,libjanus_textroom.so,libjanus_videocall.so"
    }
    loggers: {
      disable = "libjanus_jsonlog.so"
    }
    nat: {
      stun_server = "turn.${config.pub-solar-os.networking.domain}"
      stun_port = "${toString config.services.coturn.listening-port}"
      full_trickle = true
      turn_rest_api_key = "##JANUSAPIKEY##"
    }
  '';

  bootstrapConfig = pkgs.writeShellScript "bootstrap-janus" ''
    CFG=/etc/janus/janus.jcfg

    cp -f ${janusCfg} ''${CFG}
    sed -ri "s/##JANUSAPIKEY##/$(cat ${cfg.apiKeyFile})/g" ''${CFG}

    chown janus:janus ''${CFG}
  '';
in
{
  options.pub-solar-os.janus-gw =
    let
      inherit (lib) mkOption mkEnableOption types;
    in
    {
      enable = mkEnableOption "enable janus-gw";
      apiKeyFile = mkOption {
        description = "File that holds the janus server api key";
        type = types.str;
      };
    };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."${domain}" = {
      forceSSL = true;
      enableACME = true;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${wsPort}/";
          proxyWebsockets = true;
        };
        "/janus" = {
          proxyPass = "http://127.0.0.1:${httpPort}/janus";
          proxyWebsockets = true;
        };
      };
    };

    environment.etc = {
      "janus/janus.plugin.streaming.jcfg".text = ''
        general: {
        }

      '';
      "janus/janus.plugin.videoroom.jcfg".text = ''
        general: {
        }
      '';
      "janus/janus.transport.http.jcfg".text = ''
        general: {
          base_path = "/janus"
          http = true
          port = ${httpPort}
          ip = "127.0.0.1"
          https = false
          acl = "127.,"
          acl_forwarded = true
        }

        admin: {
          admin_base_path= "/admin"
          admin_http = true
          admin_port = 7088
          admin_https = false
          ip = "127.0.0.1"
        }
      '';

      "janus/janus.transport.websockets.jcfg".text = ''
        general: {
                json = "indented"				# Whether the JSON messages should be indented (default),
                                                                                # plain (no indentation) or compact (no indentation and no spaces)
                ws = true						# Whether to enable the WebSockets API
                ws_port = ${wsPort}					# WebSockets server port
                ws_ip = "127.0.0.1"			# Whether we should bind this server to a specific IP address only
                wss = false						# Whether to enable secure WebSockets
        }
      '';
    };

    users.groups."janus" = { };
    users.users."janus" = {
      isSystemUser = true;
      group = "janus";
    };

    systemd.services.janus = {
      after = [ "coturn.service" ];
      serviceConfig = {
        StateDirectory = "janus";
        LimitNOFILE = 65536;
        ExecStartPre = "!${bootstrapConfig}";
        ExecStart = "${pkgs.janus-gateway}/bin/janus -F /etc/janus";
        User = "janus";
        Group = "janus";
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
