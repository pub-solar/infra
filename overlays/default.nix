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
              in
              {
                codeberg-pages = unstable.codeberg-pages.overrideAttrs (oldAttrs: {
                  patches = [ ./0001-workaround-don-t-change-ssl-port-in-redirect.patch ];
                });
                draupnir = unstable.draupnir;
                element-themes = prev.callPackage ./pkgs/element-themes { inherit (inputs) element-themes; };
                element-stickerpicker = prev.callPackage ./pkgs/element-stickerpicker {
                  inherit (inputs) element-stickers maunium-stickerpicker;
                };
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
