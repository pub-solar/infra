{ flake, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    ./networking.nix
    ./wireguard.nix
    ./backups.nix
  ];
}
