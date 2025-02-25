{ flake, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    ./networking.nix
    ./wireguard.nix
    ./forgejo-actions-runner.nix
    #./backups.nix
  ];
}
