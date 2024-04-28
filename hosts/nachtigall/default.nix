{ flake, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./configuration.nix

      ./networking.nix
      ./wireguard.nix
      ./backups.nix

    ];
}
