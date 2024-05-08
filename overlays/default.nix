{ self, inputs, ... }:
{
  flake = {
    nixosModules = rec {
      overlays = (
        { ... }:
        {
          nixpkgs.overlays = [
            (
              final: prev:
              let
                unstable = import inputs.unstable { system = prev.system; };
                nixpkgs-draupnir = import inputs.nixpkgs-draupnir { system = prev.system; };
              in
              {
                draupnir = nixpkgs-draupnir.draupnir;
                element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
                element-stickerpicker = prev.callPackage ./pkgs/element-stickerpicker {
                  inherit (inputs) element-stickers maunium-stickerpicker;
                };
              }
            )
          ];
        }
      );
    };
  };
}
