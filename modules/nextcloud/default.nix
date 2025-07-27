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
}
