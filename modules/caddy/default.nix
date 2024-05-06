{ config
, lib
, pkgs
, flake
, ...
}:
{
  systemd.tmpfiles.rules = [
    "d '/data/srv/www/os/download/' 0750 ${config.pub-solar-os.authentication.robot.username} ${config.pub-solar-os.authentication.robot.username} - -"
  ];

  services.caddy = {
    enable = lib.mkForce true;
    group = config.pub-solar-os.authentication.robot.username;
    email = config.pub-solar-os.adminEmail;
    enableReload = true;
    globalConfig = lib.mkForce ''
      grace_period 60s
    '';
    virtualHosts = {
      "flora-6.pub.solar" = {
        logFormat = lib.mkForce ''
          output discard
        '';
        extraConfig = ''
                    basicauth * {
                ${config.pub-solar-os.authentication.robot.username} $2a$14$mmIAy/Ezm6YGohUtXa2mWeW6Bcw1MQXPhrRbz14jAD2iUu3oob/t.
                    }
                    reverse_proxy :${toString config.services.loki.configuration.server.http_listen_port}
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
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}