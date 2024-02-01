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
                 version = "4.2.5";
                 patches = [
                   (final.fetchpatch {
                     url = "https://github.com/mastodon/mastodon/compare/v4.2.4...v4.2.5.patch";
                     hash = "sha256-CtzYV1i34s33lV/1jeNcr9p/x4Es1zRaf4l1sNWVKYk=";
                   })
                 ];
               };
            })
        ];
      });
    };
  };
}
