{
  flake,
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  age.secrets.keycloak-database-password = {
    file = "${flake.self}/secrets/keycloak-database-password.age";
    mode = "700";
    #owner = "keycloak";
  };

  services.caddy.virtualHosts."auth.pub.solar" = {
    # logFormat = lib.mkForce ''
    #   output discard
    # '';
    extraConfig = ''
      redir / /realms/pub.solar/account temporary
      reverse_proxy :8080
    '';
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
      "pub.solar" = inputs.keycloak-theme-pub-solar.legacyPackages.${pkgs.system}.keycloak-theme-pub-solar;
    };
  };
}
