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
            mastodon = inputs.unstable.legacyPackages.${prev.system}.mastodon;
            forgejo = inputs.unstable.legacyPackages.${prev.system}.forgejo;
            forgejo-actions-runner = inputs.unstable.legacyPackages.${prev.system}.forgejo-actions-runner;

            mediawiki = inputs.unstable.legacyPackages.${prev.system}.mediawiki;

            element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
          })
        ];
      });
    };
  };
}
