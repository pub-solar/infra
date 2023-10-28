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
          })
        ];
      });
    };
  };
}
