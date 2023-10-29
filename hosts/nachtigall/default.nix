{ ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./configuration.nix

      ./networking.nix
      ./nix.nix
      ./apps/nginx.nix

      ./apps/keycloak.nix
      ./apps/mailman.nix
      ./apps/mastodon.nix
      ./apps/nginx-mastodon.nix
      ./apps/nginx-mastodon-files.nix
      ./apps/nginx-website.nix
      ./apps/opensearch.nix
      ./apps/postgresql.nix
      ./apps/forgejo.nix
    ];
}
