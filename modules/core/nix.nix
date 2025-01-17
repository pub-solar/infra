{
  config,
  pkgs,
  lib,
  flake,
  ...
}:
{
  nixpkgs.config = lib.mkDefault {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
    permittedInsecurePackages = [ "olm-3.2.16" ];
  };

  system.activationScripts.diff-closures = {
    text = ''
      if [[ -e /run/current-system ]]; then
        ${config.nix.package}/bin/nix store diff-closures \
          /run/current-system "$systemConfig" \
          --extra-experimental-features nix-command
      fi
    '';
    supportsDryActivation = true;
  };

  nix = {
    # Use default version alias for nix package
    package = pkgs.nix;
    gc.automatic = true;
    optimise.automatic = true;

    registry = {
      nixpkgs.flake = flake.inputs.nixpkgs;
      unstable.flake = flake.inputs.unstable;
      system.flake = flake.self;
    };

    settings = {
      # Improve nix store disk usage
      auto-optimise-store = true;
      # Prevents impurities in builds
      sandbox = true;
      # Give root and @wheel special privileges with nix
      trusted-users = [
        "root"
        "@wheel"
      ];
      # Allow only group wheel to connect to the nix daemon
      allowed-users = [ "@wheel" ];
    };

    # Generally useful nix option defaults
    extraOptions = lib.mkForce ''
      experimental-features = flakes nix-command
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';

    nixPath = [
      "nixpkgs=${flake.inputs.nixpkgs}"
      "nixos-config=${../../lib/compat/nixos}"
      "home-manager=${flake.inputs.home-manager}"
    ];
  };
}
