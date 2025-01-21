{ flake, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./configuration.nix

    ./networking.nix
    ./wireguard.nix
    ./backups.nix
    "${flake.inputs.fork}/nixos/modules/services/matrix/matrix-authentication-service.nix"
    "${flake.inputs.fork-irc}/nixos/modules/services/matrix/appservice-irc.nix"
  ];

  disabledModules = [
    "services/matrix/matrix-authentication-service.nix"
    "services/matrix/appservice-irc.nix"
  ];
}
