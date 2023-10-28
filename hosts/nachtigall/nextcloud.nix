{ config, pkgs, ... }:
{
  services.caddy.virtualHosts."cloud.pub.solar" = {
    # logFormat = lib.mkForce ''
    #   output discard
    # '';
    extraConfig = ''
      reverse_proxy :8080
    '';
  };

  services.nginx.virtualHosts."localhost".listen = [ { addr = "127.0.0.1"; port = 8080; } ];

  services.nextcloud = {
    enable = true;
    https = true;
    secretFile = ""; # secret

    notify_push = {
      enable = true;
    };

    config = {
      adminuser = "admin";
      dbuser = "nextcloud";
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbtableprefix = "oc_";
      trustedProxies = [
        "cloud.pub.solar"
      ];
    };

    autoUpdateApps.enable = true;
    database.createLocally = true;
  };
}
