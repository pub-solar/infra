{ flake, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./configuration.nix

    ./networking.nix
    ./wireguard.nix
    ./backups.nix
    "${flake.inputs.fork}/nixos/modules/services//matrix/matrix-authentication-service.nix"
    "${flake.inputs.unstable}/nixos/modules/services/web-apps/mastodon.nix"
  ];

  disabledModules = [
    "services/matrix/matrix-authentication-service.nix "
    "services/web-apps/mastodon.nix"
  ];
}
