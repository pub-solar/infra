{
  self,
  inputs,
  config,
  ...
}:
{
  flake = {
    nixosModules = {
      home-manager = {
        imports = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              flake = {
                inherit self inputs config;
              };
            };
          }
        ];
      };
    };
    nixosConfigurations = {
      nachtigall = self.inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          flake = {
            inherit self inputs config;
          };
        };
        modules = [
          self.inputs.agenix.nixosModules.default
          self.nixosModules.home-manager
          self.nixosModules.core
          ./nachtigall
          self.nixosModules.overlays
          self.nixosModules.unlock-zfs-on-boot
          self.nixosModules.docker
          self.nixosModules.backups

          self.nixosModules.nginx
          self.nixosModules.collabora
          self.nixosModules.coturn
          self.nixosModules.forgejo
          self.nixosModules.keycloak
          self.nixosModules.mailman
          self.nixosModules.mastodon
          self.nixosModules.nginx-mastodon
          self.nixosModules.nginx-mastodon-files
          self.nixosModules.mediawiki
          self.nixosModules.mollysocket
          self.nixosModules.nextcloud
          self.nixosModules.nginx-website
          self.nixosModules.nginx-website-miom
          self.nixosModules.opensearch
          self.nixosModules.owncast
          self.nixosModules.postgresql
          self.nixosModules.prometheus-exporters
          self.nixosModules.promtail
          self.nixosModules.searx
          self.nixosModules.tmate
          self.nixosModules.tt-rss
          self.nixosModules.obs-portal
          self.nixosModules.matrix
          self.nixosModules.matrix-draupnir
          self.nixosModules.matrix-irc
          self.nixosModules.matrix-telegram
          self.nixosModules.nginx-matrix
        ];
      };

      metronom = self.inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          flake = {
            inherit self inputs config;
          };
        };
        modules = [
          self.inputs.agenix.nixosModules.default
          self.nixosModules.home-manager
          self.nixosModules.core
          ./metronom
          self.nixosModules.overlays
          self.nixosModules.unlock-zfs-on-boot
          self.nixosModules.backups
          self.nixosModules.mail
          self.nixosModules.prometheus-exporters
          self.nixosModules.promtail

          self.inputs.simple-nixos-mailserver.nixosModule
        ];
      };

      tankstelle = self.inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          flake = {
            inherit self inputs config;
          };
        };
        modules = [
          self.inputs.agenix.nixosModules.default
          self.nixosModules.home-manager
          self.nixosModules.core
          ./tankstelle
          self.nixosModules.overlays
          self.nixosModules.backups
          self.nixosModules.prometheus-exporters
          self.nixosModules.promtail
          self.nixosModules.forgejo-actions-runner
        ];
      };

      trinkgenossin = self.inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          flake = {
            inherit self inputs config;
          };
        };
        modules = [
          self.inputs.agenix.nixosModules.default
          self.nixosModules.home-manager
          self.nixosModules.core
          ./trinkgenossin
          self.nixosModules.backups
          self.nixosModules.overlays
          self.nixosModules.unlock-luks-on-boot

          self.nixosModules.garage
          self.nixosModules.nginx

          # This module is already using options, and those options are used by the grafana module
          self.nixosModules.keycloak
          self.nixosModules.codeberg-pages
          self.nixosModules.grafana
          self.nixosModules.prometheus
          self.nixosModules.prometheus-exporters
          self.nixosModules.loki
          self.nixosModules.promtail
          self.nixosModules.forgejo-actions-runner
        ];
      };

      delite = self.inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          flake = {
            inherit self inputs config;
          };
        };
        modules = [
          self.inputs.agenix.nixosModules.default
          self.inputs.disko.nixosModules.disko
          self.nixosModules.home-manager
          self.nixosModules.core
          ./delite
          self.nixosModules.overlays
          self.nixosModules.unlock-luks-on-boot
          self.nixosModules.prometheus-exporters
          self.nixosModules.promtail

          self.nixosModules.garage
          self.nixosModules.nginx
        ];
      };

      blue-shell = self.inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          flake = {
            inherit self inputs config;
          };
        };
        modules = [
          self.inputs.agenix.nixosModules.default
          self.inputs.disko.nixosModules.disko
          self.nixosModules.home-manager
          self.nixosModules.core
          ./blue-shell
          self.nixosModules.overlays
          self.nixosModules.unlock-luks-on-boot
          self.nixosModules.prometheus-exporters
          self.nixosModules.promtail

          self.nixosModules.garage
          self.nixosModules.nginx
        ];
      };

      underground = self.inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          flake = {
            inherit self inputs config;
          };
        };
        modules = [
          self.inputs.agenix.nixosModules.default
          self.nixosModules.home-manager
          self.nixosModules.core
          ./underground
          self.nixosModules.overlays
          self.nixosModules.unlock-luks-on-boot

          self.nixosModules.backups
          self.nixosModules.keycloak
          self.nixosModules.postgresql
          self.nixosModules.matrix
          self.nixosModules.matrix-draupnir
          self.nixosModules.matrix-irc
          self.nixosModules.nginx
          self.nixosModules.nginx-matrix
        ];
      };
    };
  };
}
