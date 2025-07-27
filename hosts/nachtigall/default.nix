{ flake, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    ./backups.nix
    ./networking.nix
    ./nextcloud.nix
    ./prometheus-exporters.nix
    ./wireguard.nix

    "${flake.inputs.fork}/nixos/modules/services/matrix/matrix-authentication-service.nix"
  ];

  disabledModules = [
    "services/matrix/matrix-authentication-service.nix"
  ];
}
