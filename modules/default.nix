{ self, ... }:
{
  flake = {
    nixosModules = rec {
      core = import ./core;

      unlock-zfs-on-boot = import ./unlock-zfs-on-boot.nix;
      docker = import ./docker.nix;

      caddy = import ./apps/caddy.nix;
      collabora = import ./apps/collabora.nix;
      coturn = import ./apps/coturn.nix;
      drone = import ./apps/drone.nix;
      forgejo-actions-runner = import ./apps/forgejo/forgejo-actions-runner.nix;
      forgejo = import ./apps/forgejo/forgejo.nix;
      grafana = import ./apps/grafana/grafana.nix;
      keycloak = import ./apps/keycloak.nix;
      loki = import ./apps/loki.nix;
      mailman = import ./apps/mailman.nix;
      mastodon = import ./apps/mastodon/mastodon.nix;
      nginx-mastodon = import ./apps/mastodon/nginx-mastodon.nix;
      nginx-mastodon-files = import ./apps/mastodon/nginx-mastodon-files.nix;
      matrix = import ./apps/matrix/synapse.nix;
      nginx-matrix = import ./apps/matrix/nginx-matrix.nix;
      matrix-telegram = import ./apps/matrix/mautrix-telegram.nix;
      matrix-irc = import ./apps/matrix/irc.nix;
      mediawiki = import ./apps/mediawiki.nix;
      nextcloud = import ./apps/nextcloud/nextcloud.nix;
      nginx-website-miom = import ./apps/nginx-website-miom.nix;
      nginx-website = import ./apps/nginx-website.nix;
      nginx = import ./apps/nginx.nix;
      obs-portal = import ./apps/obs-portal.nix;
      opensearch = import ./apps/opensearch.nix;
      owncast = import ./apps/owncast.nix;
      postgresql = import ./apps/postgresql.nix;
      prometheus = import ./apps/prometheus/prometheus.nix;
      prometheus-exporters = import ./apps/prometheus/prometheus-exporters.nix;
      nginx-prometheus-exporters = import ./apps/prometheus/nginx-prometheus-exporters.nix;
      promtail = import ./apps/promtail.nix;
      searx = import ./apps/searx.nix;
      tmate = import ./apps/tmate.nix;
    };
  };
}
