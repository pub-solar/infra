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
            mastodon = inputs.mastodon-fork.legacyPackages.${prev.system}.mastodon;
            forgejo-actions-runner = inputs.unstable.legacyPackages.${prev.system}.forgejo-actions-runner;

            mediawiki = inputs.unstable.legacyPackages.${prev.system}.mediawiki;
          })
        ];
      });
    };
  };
}
