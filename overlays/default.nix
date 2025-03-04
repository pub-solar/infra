{ inputs, ... }:
{
  flake = {
    nixosModules = {
      overlays = (
        { ... }:
        {
          nixpkgs.overlays = [
            (
              final: prev:
              let
                unstable = import inputs.unstable { system = prev.system; };
              in
              {
                matrix-authentication-service = unstable.matrix-authentication-service;
                element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
                element-stickerpicker = prev.callPackage ./pkgs/element-stickerpicker {
                  inherit (inputs) element-stickers maunium-stickerpicker;
                };
                matrix-cache-gc = prev.callPackage ./pkgs/matrix-cache-gc.nix { inherit inputs; };
                nextcloud-skeleton = prev.callPackage ./pkgs/nextcloud-skeleton { };
              }
            )
          ];
        }
      );
    };
  };
}
