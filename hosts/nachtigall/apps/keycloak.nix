{
  flake,
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.keycloak-database-password = {
    file = "${flake.self}/secrets/keycloak-database-password.age";
    mode = "700";
    #owner = "keycloak";
  };

  services.nginx.virtualHosts."auth.pub.solar" = {
    enableACME = true;
    forceSSL = true;

    locations = {
      "= /" = {
        extraConfig = ''
          return 302 /realms/pub.solar/account;
        '';
      };

      "/" = {
        extraConfig = ''
          proxy_pass http://127.0.0.1:8080;
          proxy_buffer_size 8k;
        '';
      };
    };
  };

  # keycloak
  services.keycloak = {
    enable = true;
    database.passwordFile = config.age.secrets.keycloak-database-password.path;
    settings = {
      hostname = "auth.pub.solar";
      http-host = "127.0.0.1";
      http-port = 8080;
      proxy = "edge";
      features = "declarative-user-profile";
    };
    themes = {
      "pub.solar" = flake.inputs.keycloak-theme-pub-solar.legacyPackages.${pkgs.system}.keycloak-theme-pub-solar;
    };
  };
}
