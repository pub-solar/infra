{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  maintenanceMode = {
    logFormat = lib.mkForce ''
      output discard
    '';
    extraConfig = ''
      @notFound `{err.status_code} == 404`

      @websitePages {
        path /
        path /about
        path /hakken
        path /privacy
        path /os
      }

      error @websitePages "Scheduled Maintenance" 503

      handle {
        root * /srv/www/pub.solar
        try_files {path}.html {path}
        file_server
      }

      handle_errors @notFound {
        error * "Scheduled Maintenance" 503
      }

      handle_errors {
        root * /srv/www/pub.solar
        rewrite * /maintenance/index.html
        file_server
      }
    '';
  };
in {
  disabledModules = [
    "services/web-servers/caddy/default.nix"
  ];

  imports = [
    "${flake.inputs.unstable}/nixos/modules/services/web-servers/caddy/default.nix"
  ];

  systemd.tmpfiles.rules = [
    "d '/data/srv/www/os/download/' 0750 hakkonaut hakkonaut - -"
  ];

  services.caddy = {
    enable = lib.mkForce true;
    group = "hakkonaut";
    email = "admins@pub.solar";
    globalConfig = lib.mkForce ''
      grace_period 60s
    '';
  };
  networking.firewall.allowedTCPPorts = [80 443];
}
