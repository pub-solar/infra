{ config, flake, ... }:
{
  age.secrets."nextcloud-secrets" = {
    file = "${flake.self}/secrets/staging-nextcloud-secrets.age";
    mode = "400";
    owner = "nextcloud";
  };

  age.secrets."nextcloud-admin-pass" = {
    file = "${flake.self}/secrets/staging-nextcloud-admin-pass.age";
    mode = "400";
    owner = "nextcloud";
  };

  pub-solar-os.nextcloud = {
    trustedProxies = [
      "80.244.242.3"
    ];
    adminPasswordFile = config.age.secrets."nextcloud-admin-pass".path;
    secretsFile = config.age.secrets."nextcloud-secrets".path;
  };
}
