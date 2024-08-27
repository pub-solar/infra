{ flake, lib, ... }:

{
  imports = [
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  security.acme.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
  security.acme.preliminarySelfsigned = true;

  networking.useDHCP = true;
  networking.interfaces."enp35s0".ipv4.addresses = [
    {
      address = "10.0.0.1";
      prefixLength = 26;
    }
  ];
  networking.interfaces."enp35s0".ipv6.addresses = [
    {
      address = "2a01:4f8:172:1c25::1";
      prefixLength = 64;
    }
  ];
}
