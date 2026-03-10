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
  pub-solar-os.nextcloud = {
    trustedProxies = [
      "138.201.80.102"
      "2a01:4f8:172:1c25::1"
    ];
    adminPasswordFile = config.age.secrets."nextcloud-admin-pass".path;
    secretsFile = config.age.secrets."nextcloud-secrets".path;
  };
}
