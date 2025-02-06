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
                fork = import inputs.fork { system = prev.system; };
              in
              {
                matrix-authentication-service = fork.matrix-authentication-service;
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
