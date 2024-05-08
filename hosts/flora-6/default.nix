{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./configuration.nix
    ./triton-vmtools.nix
    ./wireguard.nix
  ];
}
