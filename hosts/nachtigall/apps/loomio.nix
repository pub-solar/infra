{ config
, lib
, pkgs
, self
, ...
}: let
  uid = 980;
  gid = 979;
in {
  age.secrets.loomio-environment = {
    file = "${flake.self}/secrets/loomio-environment.age";
    symlink = false;
    mode = "440";
    owner = "loomio";
    group = "loomio";
  };

  services.postgresql = {
    authentication = ''
      host loomio all 172.17.0.0/16 password
    '';
  };

  users.users.loomio = {
    isSystemUser = true;
    group = "loomio";
    inherit uid;
  };
  users.groups.loomio = { inherit gid; };

  services.nginx.virtualHosts."decide.pub.solar" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyWebsockets = true;
      extraConfig = ''
        proxy_pass http://127.0.0.1:3001;
        proxy_set_header Host $host;
      '';
    };
  };

  services.nginx.virtualHosts."channels.decide.pub.solar" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyWebsockets = true;
      extraConfig = ''
        proxy_pass http://127.0.0.1:3001;
        proxy_set_header Host $host;
      '';
    };
  };

  virtualisation = {
    oci-containers = let 
      loomioConfig = {
        image = "loomio/loomio:stable";

        autoStart = true;

        volumes = [
          "/run/redis-loomio/redis.sock:/run/redis/redis.sock"
          "/var/lib/loomio/uploads:/loomio/public/system"
          "/var/lib/loomio/storage:/loomio/storage"
          "/var/lib/loomio/files:/loomio/public/files"
          "/var/lib/loomio/plugins:/loomio/plugins/docker"
          "/var/lib/loomio/tmp:/loomio/tmp"
        ];

        extraOptions = [
          "--add-host=host.docker.internal:host-gateway"
          "--pull=always"
        ];

        environmentFiles = [ config.age.secrets.loomio-environment.path ];

        environment = {
          CANONICAL_HOST = "";
          SUPPORT_EMAIL = "";
          SITE_NAME = "";
          REPLY_HOSTNAME = "";
          CHANNELS_URI = "";
          HELPER_BOT_EMAIL = "no-reply@";

          SMTP_AUTH = "plain";
          SMTP_DOMAIN = "";
          SMTP_SERVER = "smtp.example.com";
          SMTP_PORT = "465";
          SMTP_USE_SSL = "1";

          ACTIVE_STORAGE_SERVICE = "local";

          ALLOW_ROBOTS = "0";

          THEME_ICON_SRC = "/files/icon.png";
          THEME_APP_LOGO_SRC = "/files/logo.svg";
          THEME_EMAIL_HEADER_LOGO_SRC = "/files/logo_128h.png";
          THEME_EMAIL_FOOTER_LOGO_SRC = "/files/logo_64h.png";

          # used in emails. use rgb or hsl values, not hex
          THEME_PRIMARY_COLOR = "rgb(255,167,38)";
          THEME_ACCENT_COLOR = "rgb(0,188,212)";
          THEME_TEXT_ON_PRIMARY_COLOR = "rgb(255,255,255)";
          THEME_TEXT_ON_ACCENT_COLOR = "rgb(255,255,255)";

          REDIS_URL = "unix:///run/redis/redis.sock";

          CHANNELS_URI = "wss://channels.";

          RAILS_ENV = "production";
        };
      };
    in {
      backend = "docker";

      containers."loomio" = loomioConfig // {
        ports = [ "127.0.0.1:3001:3000" ];
        volumes = [ "/var/lib/loomio/import:/import" ];
      };

      containers."loomio-worker" = loomioConfig // {
        environment = {
          TASK = "worker";
        };
        volumes = [ "/var/lib/loomio/import:/import" ];
      };

      containers."loomio-mailin" = {
        image = "loomio/mailin-docker:latest";
        autoStart = true;
      };

      containers."loomio-channels" = {
        image = "loomio/loomio_channel_server";
        autoStart = true;
        environmentFiles = [ config.age.secrets.loomio-environment.path ];
      };
    };
  };

  services.redis.servers.loomio.enable = true;
}
