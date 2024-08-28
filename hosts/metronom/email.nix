{ config, flake, ... }: {
  age.secrets.mail-hensoko.file = "${flake.self}/secrets/mail/hensoko.age";
  age.secrets.mail-teutat3s.file = "${flake.self}/secrets/mail/teutat3s.age";
  age.secrets.mail-admins.file = "${flake.self}/secrets/mail/admins.age";
  age.secrets.mail-bot.file = "${flake.self}/secrets/mail/bot.age";
  age.secrets.mail-crew.file = "${flake.self}/secrets/mail/crew.age";
  age.secrets.mail-erpnext.file = "${flake.self}/secrets/mail/erpnext.age";
  age.secrets.mail-hakkonaut.file = "${flake.self}/secrets/mail/hakkonaut.age";

  mailserver = {
    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -R11 -m bcrypt'
    loginAccounts = {
      "admins@${config.pub-solar-os.networking.domain}" = {
        hashedPasswordFile = config.age.secrets.mail-admins.path;
      };
      "hakkonaut@${config.pub-solar-os.networking.domain}" = {
        hashedPasswordFile = config.age.secrets.mail-hakkonaut.path;
      };

      "hensoko@pub.solar" = {
        hashedPasswordFile = config.age.secrets.mail-hensoko.path;
        quota = "2G";
      };
      "teutat3s@pub.solar" = {
        hashedPasswordFile = config.age.secrets.mail-teutat3s.path;
        quota = "2G";
      };
      "bot@pub.solar" = {
        hashedPasswordFile = config.age.secrets.mail-bot.path;
        quota = "2G";
        aliases = [ "hackernews-bot@pub.solar" ];
      };
      "crew@pub.solar" = {
        hashedPasswordFile = config.age.secrets.mail-crew.path;
        quota = "2G";
        aliases = [ "moderation@pub.solar" ];
      };
      "erpnext@pub.solar" = {
        hashedPasswordFile = config.age.secrets.mail-erpnext.path;
        quota = "2G";
      };
    };
  };
}
