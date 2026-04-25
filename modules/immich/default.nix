{ config, lib, flake, ... }:

let
  vHostDomain = "photos.${config.pub-solar-os.networking.domain}";
  cfg = config.pub-solar-os.immich;
in
{
  imports = [
    "${flake.inputs.unstable}/nixos/modules/services/web-apps/immich.nix"
  ];

  disabledModules = [
    "services/web-apps/immich.nix"
  ];

  options.pub-solar-os.immich = {
    oauthIssuerUrl = lib.mkOption {
      description = -"URL to the .well-known/openid-configuration";
      type = lib.types.str;
    };
    oauthClientId = lib.mkOption {
      description = "OAuth client id";
      type = lib.types.str;
    };
    oauthClientSecretFile = lib.mkOption {
      description = "Path to OAuth client secret file";
      type = lib.types.path;
    };
  };
  config = {
    services.immich = {
      enable = true;
      environment = {
        IMMICH_TELEMETRY_INCLUDE = "all";
        IMMICH_API_METRICS_PORT = "9206";
        IMMICH_MICROSERVICES_METRICS_PORT = "9207";
        # IMMICH_LOG_LEVEL = "warn";
      };
      settings = {
        oauth = {
          enabled = true;

          issuerUrl = cfg.oauthIssuerUrl;
          clientId = cfg.oauthClientId;
          clientSecret._secret = cfg.oauthClientSecretFile;

          autoLaunch = true;
          buttonText = "Login with pub.solar ID";

          autoRegister = true;
          defaultStorageQuota = 1; # GB
        };
      };
    };

    services.nginx.virtualHosts."${vHostDomain}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.immich.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };
  };
}
