{
  flake,
  ...
}:
{
  imports = [
    ./backup.nix
    ./image-previews.nix
    ./nextcloud.nix
    ./nginx.nix
    ./talk.nix
  ];

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
}
