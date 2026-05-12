{ config, flake, ... }:
{
  age.secrets."nextcloud-secrets" = {
    file = "${flake.self}/secrets/nextcloud-secrets.age";
    mode = "400";
    owner = "nextcloud";
  };

  age.secrets."nextcloud-admin-pass" = {
    file = "${flake.self}/secrets/nextcloud-admin-pass.age";
    mode = "400";
    owner = "nextcloud";
  };

  age.secrets."nextcloud-whiteboard-server-secrets" = {
    file = "${flake.self}/secrets/nextcloud-whiteboard-server-secrets.age";
    mode = "400";
    owner = "nextcloud";
  };

  pub-solar-os.nextcloud = {
    trustedProxies = [
      "138.201.80.102"
      "2a01:4f8:172:1c25::1"
    ];
    adminPasswordFile = config.age.secrets."nextcloud-admin-pass".path;
    secretsFile = config.age.secrets."nextcloud-secrets".path;
  };

  pub-solar-os.nextcloud-signaling = {
    enable = true;
    internalSecretFile = config.age.secrets."signaling-internal-secret".path;
    hashKeyFile = config.age.secrets."signaling-hash-key".path;
    blockKeyFile = config.age.secrets."signaling-block-key".path;
    janusApiKeyFile = config.age.secrets."janus-api-key".path;
    turnSecretFile = config.age.secrets."coturn-static-auth-secret".path;
    nextcloudSecretFile = config.age.secrets."signaling-nextcloud-secret".path;
  };

  pub-solar-os.nextcloud-whiteboard = {
    enable = true;
    secretFile = config.age.secrets."nextcloud-whiteboard-server-secrets".path;
  };
}
