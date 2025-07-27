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

  age.secrets."nextcloud-talk-coturnStaticAuthSecret" = {
    file = "${flake.self}/secrets/nextcloud-talk-coturn-static-auth-secret.age";
    mode = "400";
    owner = "nextcloud";
  };

  age.secrets."nextcloud-talk-signalingSecret" = {
    file = "${flake.self}/secrets/nextcloud-talk-signaling-secret.age";
    mode = "400";
    owner = "nextcloud";
  };

  pub-solar-os.nextcloud.talk = {
    enable = true;
    coturnStaticAuthSecretFile = config.age.secrets."nextcloud-talk-coturnStaticAuthSecret".path;
    signalingSecretFile = config.age.secrets."nextcloud-talk-signalingSecret".path;
  };

  pub-solar-os.coturn = {
    enable = true;
    staticAuthSecretFile = config.age.secrets."nextcloud-talk-coturnStaticAuthSecret".path;
    interface = "enp35s0";
  };
}
