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
                unstable = import inputs.unstable { system = prev.system; };
                nixpkgs-draupnir = import inputs.nixpkgs-draupnir { system = prev.system; };
              in
              {
                # Patch to always use port 443 in redirects from http -> https
                # instead of changing it to pages-server PORT
                codeberg-pages = unstable.codeberg-pages.overrideAttrs (oldAttrs: {
                  patches = [ ./0001-workaround-don-t-change-ssl-port-in-redirect.patch ];
                });
                # want draupnir v2.3.1
                draupnir = nixpkgs-draupnir.draupnir;
                element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
                element-stickerpicker = prev.callPackage ./pkgs/element-stickerpicker {
                  inherit (inputs) element-stickers maunium-stickerpicker;
                };
                # Want element-web 1.11.103
                element-web = unstable.element-web;
                # want synapse-http-antispam version 0.4.0
                synapse-http-antispam = prev.callPackage ./pkgs/synapse-http-antispam { };
                nextcloud-skeleton = prev.callPackage ./pkgs/nextcloud-skeleton { };
                delete-pubsolar-id = prev.callPackage ./pkgs/delete-pubsolar-id { };
              }
            )
          ];
        }
      );
    };
  };
}
