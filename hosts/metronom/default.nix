{ flake, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    ./networking.nix
    ./mail.nix
    ./wireguard.nix
    #./backups.nix
  ];
}
