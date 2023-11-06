{
  flake,
  config,
  ...
}: {
  age.secrets.invidious-database-password = {
    file = "${flake.self}/secrets/invidious-database-password.age";
    mode = "600";
    owner = "invidious";
  };
  age.secrets.invidious-extra-settings = {
    file = "${flake.self}/secrets/invidious-extra-settings.age";
    mode = "600";
    owner = "invidious";
  };

  services.invidious = {
    enable = true;
    domain = "tube.pub.solar";
    nginx.enable = true;

    database.passwordFile = config.age.secrets.invidious-database-password.path;
    settings = {
      db = {
        user = "invidious";
        dbname = "invidious";
      };
    };
    extraSettingsFile = config.age.secrets.invidious-extra-settings.path;
  };
}
