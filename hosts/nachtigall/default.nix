{ flake, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./configuration.nix

      ./networking.nix
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
      ./apps/owncast.nix
      ./apps/nginx-mastodon.nix
      ./apps/nginx-mastodon-files.nix
      ./apps/nginx-website.nix
      ./apps/opensearch.nix
      ./apps/postgresql.nix
      ./apps/searx.nix

      ./apps/matrix/mautrix-telegram.nix
      ./apps/matrix/synapse.nix
      ./apps/matrix/irc.nix
      ./apps/nginx-matrix.nix
    ];
}
