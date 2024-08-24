{ flake, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./disk-config.nix

    ./networking.nix
    ./wireguard.nix
    #./backups.nix
  ];
}
