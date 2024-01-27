{ config, lib, pkgs, ... }:
let
  # Get port from first element in list of matrix-synapse listeners
  synapsePort = "${toString (lib.findFirst (listener: listener.port != null) "" config.services.matrix-synapse.settings.listeners).port}";
in
{
  systemd.services.matrix-appservice-irc.serviceConfig.SystemCallFilter = lib.mkForce [
    "@system-service @pkey"
    "~@privileged @resources"
    "@chown"
  ];
  services.matrix-appservice-irc = {
    enable = true;
    localpart = "irc_bot";
    port = 8010;
    registrationUrl = "http://localhost:8010";
    settings = {
      homeserver = {
        domain = "pub.solar";
        url = "http://127.0.0.1:${synapsePort}";
        media_url = "https://matrix.pub.solar";
        enablePresence = false;
      };
      ircService = {
        ident = {
          address = "::";
          enabled = false;
          port = 1113;
        };
        logging = {
          level = "debug";
          maxFiles = 5;
          toCosole = true;
        };
        matrixHandler = {
          eventCacheSize = 4096;
        };
        metrics = {
          enabled = true;
          remoteUserAgeBuckets = [ "1h" "1d" "1w" ];
        };
        provisioning = {
          enabled = false;
          requestTimeoutSeconds = 300;
        };
        servers =
          let
            commonConfig = {
              allowExpiredCerts = false;
              botConfig = {
                enabled = false;
                joinChannelsIfNoUsers = false;
                nick = "MatrixBot";
              };
              dynamicChannels = {
                createAlias = true;
                enabled = true;
                federate = true;
                joinRule = "public";
                published = true;
              };
              ircClients = {
                allowNickChanges = true;
                concurrentReconnectLimit = 50;
                idleTimeout = 10800;
                lineLimit = 3;
                maxClients = 30;
                nickTemplate = "$DISPLAY[m]";
                reconnectIntervalMs = 5000;
              };
              matrixClients = {
                joinAttempts = -1;
              };
              membershipLists = {
                enabled = true;
                floodDelayMs = 10000;
                global = {
                  ircToMatrix = {
                    incremental = true;
                    initial = true;
                  };
                  matrixToIrc = {
                    incremental = true;
                    initial = true;
                  };
                };
              };
              port = 6697;
              privateMessages = {
                enabled = true;
                federate = true;
              };
              sasl = false;
              sendConnectionMessages = true;
              ssl = true;
            };
          in
          {
            "irc.libera.chat" = lib.attrsets.recursiveUpdate commonConfig {
              name = "libera";
              dynamicChannels.groupId = "+libera.chat:localhost";
              dynamicChannels.aliasTemplate = "#_libera_$CHANNEL";
              matrixClients.displayName = "$NICK (LIBERA-IRC)";
            };
            "irc.scratch-network.net" = lib.attrsets.recursiveUpdate commonConfig {
              name = "scratch";
              matrixClients.displayName = "$NICK (SCRATCH-IRC)";
              dynamicChannels.aliasTemplate = "#_scratch_$CHANNEL";
              dynamicChannels.groupId = "+scratch-network.net:localhost";
            };
          };
      };
    };
  };
}

