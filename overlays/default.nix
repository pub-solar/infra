{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules = rec {
      overlays = ({ ... }: {
        nixpkgs.overlays = [
          (final: prev: {
            element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
          })
        ];
      });
    };
  };
}
