{ flake, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    ./networking.nix
    ./nginx.nix
    ./wireguard.nix
    ./forgejo-actions-runner.nix
    #./backups.nix
  ];
}
