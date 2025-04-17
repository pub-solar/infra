{ flake, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./configuration.nix

    ./networking.nix
    ./prometheus-exporters.nix
    ./wireguard.nix
    ./backups.nix
    "${flake.inputs.fork}/nixos/modules/services/matrix/matrix-authentication-service.nix"
  ];

  disabledModules = [
    "services/matrix/matrix-authentication-service.nix"
  ];
}
