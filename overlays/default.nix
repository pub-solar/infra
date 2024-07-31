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
                nixpkgs-331083-331168 = import inputs.nixpkgs-331083-331168 { system = prev.system; };
              in
              {
                element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
                element-stickerpicker = prev.callPackage ./pkgs/element-stickerpicker {
                  inherit (inputs) element-stickers maunium-stickerpicker;
                };
                element-web = nixpkgs-331083-331168.element-web;
                matrix-synapse-unwrapped = nixpkgs-331083-331168.matrix-synapse-unwrapped;
              }
            )
          ];
        }
      );
    };
  };
}
