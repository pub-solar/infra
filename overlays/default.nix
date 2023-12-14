{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules = rec {
      overlays = ({ ... }: {
        nixpkgs.overlays = [
          (final: prev:
          let
            release-2311 = import inputs.release-2311 {
              system = prev.system;
            };
          in
          {
            element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
            forgejo = release-2311.forgejo;
          })
          (import ./keycloak.nix)
        ];
      });
    };
  };
}
