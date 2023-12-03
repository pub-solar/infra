{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d '/data/srv/www/os/download/' 0750 hakkonaut hakkonaut - -"
  ];

  services.caddy = {
    enable = lib.mkForce true;
    group = "hakkonaut";
    email = "admins@pub.solar";
    enableReload = true;
    globalConfig = lib.mkForce ''
      grace_period 60s
    '';
    virtualHosts = {
      "ci.pub.solar" = {
        logFormat = lib.mkForce ''
          output discard
        '';
        extraConfig = ''
          reverse_proxy :4000
        '';
      };
      "grafana.pub.solar" = {
        logFormat = lib.mkForce ''
          output discard
        '';
        extraConfig = ''
          reverse_proxy :${toString config.services.grafana.settings.server.http_port}
        '';
      };
      "obs-portal.pub.solar" = {
        logFormat = lib.mkForce ''
          output discard
        '';
        extraConfig = ''
          reverse_proxy obs-portal.svc.e5756d08-36fd-424b-f8bc-acdb92ca7b82.lev-1.int.greenbaum.zone:3000
        '';
      };
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];
}
