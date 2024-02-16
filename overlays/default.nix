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
              mastodon = prev.mastodon.override {
                 version = "4.2.7";
                 patches = [
                   (final.fetchpatch {
                     url = "https://github.com/mastodon/mastodon/compare/v4.2.6...v4.2.7.patch";
                     hash = "sha256-8FhlSIHOKIEjq62+rp8QdHY87qMCtDZwjyR0HabdHig=";
                   })
                 ];

                 # Mastodon has been upgraded on master, the backport is still
                 # in progress. This is a temporary hack until the backport
                 # makes it to 23.11.
                 # https://github.com/NixOS/nixpkgs/pull/289261
                 gemset = import "${inputs.nixpkgs-head.sourceInfo.outPath}/pkgs/servers/mastodon/gemset.nix";
               };
            })
        ];
      });
    };
  };
}
