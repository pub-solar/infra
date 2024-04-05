{ flake, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./configuration.nix

      ./networking.nix
      ./wireguard.nix
      ./backups.nix
      ./apps/nginx.nix

      ./apps/collabora.nix
      ./apps/coturn.nix
      ./apps/forgejo.nix
      ./apps/keycloak.nix
      ./apps/mailman.nix
      ./apps/mastodon.nix
      ./apps/mediawiki.nix
      ./apps/nextcloud.nix
      ./apps/nginx-mastodon.nix
      ./apps/nginx-mastodon-files.nix
      ./apps/nginx-prometheus-exporters.nix
      ./apps/nginx-website.nix
      ./apps/nginx-website-miom.nix
      ./apps/opensearch.nix
      ./apps/owncast.nix
      ./apps/postgresql.nix
      ./apps/prometheus-exporters.nix
      ./apps/promtail.nix
      ./apps/searx.nix
      ./apps/tmate.nix

      ./apps/matrix/irc.nix
      ./apps/matrix/mautrix-telegram.nix
      ./apps/matrix/synapse.nix
      ./apps/nginx-matrix.nix
    ];
}
