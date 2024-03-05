{ self
, inputs
, ...
}: {
  flake = {
    nixosModules = rec {
      overlays = ({ ... }: {
        nixpkgs.overlays = [
          (final: prev:
            let
              unstable = import inputs.unstable {
                system = prev.system;
              };
            in
            {
              element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
            })
        ];
      });
    };
  };
}
