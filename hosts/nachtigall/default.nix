{ ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./configuration.nix

      ./networking.nix
      ./nix.nix

      ./apps/nginx.nix
      ./apps/nginx-website.nix
      ./apps/mastodon.nix
      ./apps/postgresql.nix
    ];
}
