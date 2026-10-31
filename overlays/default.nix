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
                nixpkgs-26-05-small = import inputs.nixpkgs-26-05-small {
                  system = prev.stdenv.hostPlatform.system;
                };
                nixpkgs-release = import inputs.nixpkgs-release { system = prev.stdenv.hostPlatform.system; };
              in
              {
                php82 = nixpkgs-26-05-small.php82;
                php83 = nixpkgs-26-05-small.php83;
                php84 = nixpkgs-26-05-small.php84;
                php85 = nixpkgs-26-05-small.php85;

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

                # Workaround nextcloud recognize face matching background job using too much memory
                # nextcloud-cron-start[1750764]: PHP Fatal error:  Allowed memory size of 1073741824 bytes exhausted (tried to allocate 327680 bytes)
                # https://github.com/nextcloud/recognize/issues/1268
                # https://github.com/nextcloud/recognize/blob/v11.0.1/lib/BackgroundJobs/ClusterFacesJob.php#L22
                nextcloud33Packages = prev.nextcloud33Packages // {
                  apps = prev.nextcloud33Packages.apps // {
                    recognize = prev.nextcloud33Packages.apps.recognize.overrideAttrs (oldAttrs: {
                      postPatch =
                        oldAttrs.postPatch
                        + ''substituteInPlace recognize/lib/BackgroundJobs/ClusterFacesJob.php --replace-fail "BATCH_SIZE = 10000" "BATCH_SIZE = 5000"'';
                    });
                  };
                };

                # want mastodon 4.6.x with themes
                mastodon = prev.callPackage ./pkgs/mastodon {
                  inherit inputs;
                  # override for security update 4.6.10, see: https://github.com/NixOS/nixpkgs/pull/580593
                  # can be reverted once 4.6.10 is in nixpkgs nixos-26.05 branch
                  # https://tracker.nixos.c3d2.de/?pr=580593
                  mastodon = nixpkgs-release.mastodon;
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
