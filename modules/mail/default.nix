{ config, flake, ... }:

{
  age.secrets.mail-hensoko.file = "${flake.self}/secrets/mail/hensoko.age";
  age.secrets.mail-teutat3s.file = "${flake.self}/secrets/mail/teutat3s.age";
  age.secrets.mail-admins.file = "${flake.self}/secrets/mail/admins.age";
  age.secrets.mail-bot.file = "${flake.self}/secrets/mail/bot.age";
  age.secrets.mail-crew.file = "${flake.self}/secrets/mail/crew.age";
  age.secrets.mail-erpnext.file = "${flake.self}/secrets/mail/erpnext.age";
  age.secrets.mail-hakkonaut.file = "${flake.self}/secrets/mail/hakkonaut.age";

  mailserver = {
    enable = true;
    fqdn = "mail.pub.solar";
    domains = [ "pub.solar" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -R11 -m bcrypt'
    loginAccounts = {
      "hensoko@pub.solar" = {
        hashedPasswordFile = config.age.secrets.mail-hensoko.path;
        quota = "2G";
      };
      "teutat3s@pub.solar" = {
        hashedPasswordFile = config.age.secrets.mail-teutat3s.path;
        quota = "2G";
      };
      "admins@pub.solar" = {
        hashedPasswordFile = config.age.secrets.mail-admins.path;
        quota = "2G";
        aliases = [
          "abuse@pub.solar"
          "alerts@pub.solar"
          "forgejo@pub.solar"
          "keycloak@pub.solar"
          "mastodon-notifications@pub.solar"
          "matrix@pub.solar"
          "postmaster@pub.solar"
          "nextcloud@pub.solar"
          "no-reply@pub.solar"
          "security@pub.solar"
        ];
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
      "hakkonaut@pub.solar" = {
        hashedPasswordFile = config.age.secrets.mail-hakkonaut.path;
        quota = "2G";
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";

    # Don't store indices along with emails
    indexDir = "/var/lib/dovecot/indices";
    fullTextSearch = {
      enable = true;
      # index new email as they arrive
      autoIndex = true;
      enforced = "body";
    };
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@pub.solar";

  pub-solar-os.backups.restic.mail = {
    paths = [
      "/var/vmail"
      "/var/dkim"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00 Etc/UTC";
    };
    initialize = true;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };
}
