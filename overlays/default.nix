{ inputs, ... }:
{
  flake = {
    nixosModules = {
      overlays = (
        { ... }:
        {
          nixpkgs.overlays = [
            (
              final: prev:
              let
                unstable = import inputs.unstable { system = prev.stdenv.hostPlatform.system; };
                nixpkgs-small = import inputs.nixpkgs-small { system = prev.stdenv.hostPlatform.system; };
              in
              {
                # Patch to always use port 443 in redirects from http -> https
                # instead of changing it to pages-server PORT
                codeberg-pages = prev.codeberg-pages.overrideAttrs (oldAttrs: {
                  patches = [ ./0001-workaround-don-t-change-ssl-port-in-redirect.patch ];
                });
                element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
                element-stickerpicker = prev.callPackage ./pkgs/element-stickerpicker {
                  inherit (inputs) element-stickers maunium-stickerpicker;
                };
                nextcloud-skeleton = prev.callPackage ./pkgs/nextcloud-skeleton { };
                delete-pubsolar-id = prev.callPackage ./pkgs/delete-pubsolar-id { };
                disable-loading-kernel-modules = prev.callPackage ./pkgs/disable-loading-kernel-modules { };

                immich = unstable.immich;

                php84 = nixpkgs-small.php84;

                # want mastodon 4.6.x with themes
                mastodon = prev.callPackage ./pkgs/mastodon {
                  inherit inputs;
                  mastodon = nixpkgs-small.mastodon;
                  themes = {
                    tangerine = {
                      paths = [
                        "${inputs.tangerine-ui}/mastodon/app/javascript/styles/tangerineui.scss"
                        "${inputs.tangerine-ui}/mastodon/app/javascript/styles/tangerineui"
                      ];
                      entrypoint = "tangerineui.scss";
                    };
                    tangerine-cherry = {
                      paths = [
                        "${inputs.tangerine-ui}/mastodon/app/javascript/styles/tangerineui-cherry.scss"
                        "${inputs.tangerine-ui}/mastodon/app/javascript/styles/tangerineui-cherry"
                      ];
                      entrypoint = "tangerineui-cherry.scss";
                    };
                    tangerine-lagoon = {
                      paths = [
                        "${inputs.tangerine-ui}/mastodon/app/javascript/styles/tangerineui-lagoon.scss"
                        "${inputs.tangerine-ui}/mastodon/app/javascript/styles/tangerineui-lagoon"
                      ];
                      entrypoint = "tangerineui-lagoon.scss";
                    };
                    tangerine-purple = {
                      paths = [
                        "${inputs.tangerine-ui}/mastodon/app/javascript/styles/tangerineui-purple.scss"
                        "${inputs.tangerine-ui}/mastodon/app/javascript/styles/tangerineui-purple"
                      ];
                      entrypoint = "tangerineui-purple.scss";
                    };
                  };
                };
              }
            )
          ];
        }
      );
    };
  };
}
