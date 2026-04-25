{ flake, config, ... }:
{
  age.secrets.immich-oauth-client-secret = {
    file = "${flake.self}/secrets/immich-oauth-client-secret.age";
    mode = "400";
    owner = "immich";
  };

  pub-solar-os.immich = {
    oauthIssuerUrl = "https://auth.pub.solar/realms/pub.solar/.well-known/openid-configuration";
    oauthClientId = "immich";
    oauthClientSecretFile = config.age.secrets.immich-oauth-client-secret.path;
  };
}
