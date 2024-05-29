{ flake, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    ./networking.nix
    ./forgejo-actions-runner.nix
    #./wireguard.nix
    #./backups.nix
  ];
}
