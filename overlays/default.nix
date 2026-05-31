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
                nixpkgs-small = import inputs.nixpkgs-small { system = prev.system; };
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
                disable-loading-kernel-modules = prev.callPackage ./pkgs/disable-loading-kernel-modules { };

                immich = unstable.immich;

                # Workaround nextcloud recognize face matching background job using too much memory
                # nextcloud-cron-start[1750764]: PHP Fatal error:  Allowed memory size of 1073741824 bytes exhausted (tried to allocate 327680 bytes)
                # https://github.com/nextcloud/recognize/issues/1268
                # https://github.com/nextcloud/recognize/blob/v10.0.7/lib/BackgroundJobs/ClusterFacesJob.php#L23
                nextcloud32Packages = prev.nextcloud32Packages // {
                  apps = prev.nextcloud32Packages.apps // {
                    recognize = prev.nextcloud32Packages.apps.recognize.overrideAttrs (oldAttrs: {
                      postPatch =
                        oldAttrs.postPatch
                        + ''substituteInPlace recognize/lib/BackgroundJobs/ClusterFacesJob.php --replace-fail "BATCH_SIZE = 10000" "BATCH_SIZE = 7000"'';
                    });
                  };
                };

                # want mastodon 4.5.x with themes
                mastodon = prev.callPackage ./pkgs/mastodon {
                  inherit inputs;
                  # can be reverted once 4.5.10 is in nixpkgs nixos-25.11 branch
                  # https://tracker.nixos.c3d2.de/?pr=522259
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
