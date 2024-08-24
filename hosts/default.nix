{ self, ... }:
{
  flake = {
    nixosConfigurations = {
      nachtigall = self.nixos-flake.lib.mkLinuxSystem {
        imports = [
          self.inputs.agenix.nixosModules.default
          self.nixosModules.home-manager
          ./nachtigall
          self.nixosModules.overlays
          self.nixosModules.unlock-zfs-on-boot
          self.nixosModules.core
          self.nixosModules.docker

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
          self.nixosModules.nextcloud
          self.nixosModules.nginx-prometheus-exporters
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
          self.nixosModules.matrix-irc
          self.nixosModules.matrix-telegram
          self.nixosModules.nginx-matrix
        ];
      };

      flora-6 = self.nixos-flake.lib.mkLinuxSystem {
        imports = [
          self.inputs.agenix.nixosModules.default
          self.nixosModules.home-manager
          ./flora-6
          self.nixosModules.overlays
          self.nixosModules.core

          self.nixosModules.keycloak
          self.nixosModules.caddy
          self.nixosModules.drone
          self.nixosModules.forgejo-actions-runner
          self.nixosModules.grafana
          self.nixosModules.prometheus
          self.nixosModules.loki
        ];
      };

      metronom = self.nixos-flake.lib.mkLinuxSystem {
        imports = [
          self.inputs.agenix.nixosModules.default
          self.nixosModules.home-manager
          ./metronom
          self.nixosModules.overlays
          self.nixosModules.unlock-zfs-on-boot
          self.nixosModules.core
          self.nixosModules.mail
          self.nixosModules.prometheus-exporters
          self.nixosModules.promtail

          self.inputs.simple-nixos-mailserver.nixosModule
        ];
      };

      tankstelle = self.nixos-flake.lib.mkLinuxSystem {
        imports = [
          self.inputs.agenix.nixosModules.default
          self.nixosModules.home-manager
          ./tankstelle
          self.nixosModules.overlays
          self.nixosModules.core
          self.nixosModules.prometheus-exporters
          self.nixosModules.promtail
        ];
      };

      trinkgenossin = self.nixos-flake.lib.mkLinuxSystem {
        imports = [
          self.inputs.agenix.nixosModules.default
          self.nixosModules.home-manager
          ./trinkgenossin
          self.nixosModules.overlays
          self.nixosModules.unlock-luks-on-boot
          self.nixosModules.core
          self.nixosModules.prometheus-exporters
          self.nixosModules.promtail

          self.nixosModules.garage
          self.nixosModules.nginx
        ];
      };

      delite = self.nixos-flake.lib.mkLinuxSystem {
        imports = [
          self.inputs.agenix.nixosModules.default
          self.inputs.disko.nixosModules.disko
          self.nixosModules.home-manager
          ./delite
          self.nixosModules.overlays
          self.nixosModules.unlock-luks-on-boot
          self.nixosModules.core
          #self.nixosModules.prometheus-exporters
          #self.nixosModules.promtail

          self.nixosModules.garage
          self.nixosModules.nginx
        ];
      };

      blue-shell = self.nixos-flake.lib.mkLinuxSystem {
        imports = [
          self.inputs.agenix.nixosModules.default
          self.inputs.disko.nixosModules.disko
          self.nixosModules.home-manager
          ./blue-shell
          self.nixosModules.overlays
          self.nixosModules.unlock-luks-on-boot
          self.nixosModules.core
          #self.nixosModules.prometheus-exporters
          #self.nixosModules.promtail

          self.nixosModules.garage
          self.nixosModules.nginx
        ];
      };
    };
  };
}
