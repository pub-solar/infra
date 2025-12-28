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
                nixpkgs-25-05 = import inputs.nixpkgs-25-05 { system = prev.system; };
                unstable = import inputs.unstable { system = prev.system; };
                anubis-rollback = import inputs.anubis-rollback { system = prev.system; };
              in
              {
                # want anubis 1.22+
                anubis = anubis-rollback.anubis;
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

                # want mastodon 4.5.x with themes
                mastodon = prev.callPackage ./pkgs/mastodon {
                  inherit inputs;
                  mastodon = prev.mastodon;
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

                tt-rss = nixpkgs-25-05.tt-rss;
              }
            )
          ];
        }
      );
    };
  };
}
