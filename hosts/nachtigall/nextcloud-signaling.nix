{ config, flake, ... }:

{
  age.secrets."signaling-nextcloud-secret" = {
    file = "${flake.self}/secrets/signaling-nextcloud-secret.age";
    mode = "400";
    owner = "nextcloud-spreed-signaling";
  };

  age.secrets."signaling-internal-secret" = {
    file = "${flake.self}/secrets/signaling-internal-secret.age";
    mode = "400";
    owner = "nextcloud-spreed-signaling";
  };

  age.secrets."janus-api-key" = {
    file = "${flake.self}/secrets/janus-api-key.age";
    mode = "440";
    owner = "janus";
    group = "nextcloud-spreed-signaling";
  };

  age.secrets."signaling-block-key" = {
    file = "${flake.self}/secrets/signaling-block-key.age";
    mode = "400";
    owner = "nextcloud-spreed-signaling";
  };

  age.secrets."signaling-hash-key" = {
    file = "${flake.self}/secrets/signaling-hash-key.age";
    mode = "400";
    owner = "nextcloud-spreed-signaling";
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
}
