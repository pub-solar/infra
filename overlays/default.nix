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
              in
              {
                element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
                element-stickerpicker = prev.callPackage ./pkgs/element-stickerpicker {
                  inherit (inputs) element-stickers maunium-stickerpicker;
                };
                mastodon = prev.mastodon.override {
                  version = "4.2.10";
                  patches = [
                    (final.fetchpatch {
                      url = "https://github.com/mastodon/mastodon/compare/v4.2.9...v4.2.10.patch";
                      hash = "sha256-268iq+2E5OOlhaJE1u5q7AFPdsloXpZCEXoyRMLtRys=";
                    })
                  ];

                  # Mastodon has been upgraded on master, the backport is still
                  # in progress. This is a temporary hack until the backport
                  # makes it to the branch nixos-24.05.
                  # https://github.com/NixOS/nixpkgs/pull/324587
                  # https://nixpk.gs/pr-tracker.html?pr=324587
                  gemset = import "${inputs.nixpkgs-head.sourceInfo.outPath}/pkgs/servers/mastodon/gemset.nix";
                };
              }
            )
          ];
        }
      );
    };
  };
}
