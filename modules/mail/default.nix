{ config, ... }:
{
  mailserver = {
    enable = true;
    fqdn = "mail.${config.pub-solar-os.networking.domain}";
    domains = [ config.pub-solar-os.networking.domain ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -R11 -m bcrypt'
    loginAccounts = {
      "admins@${config.pub-solar-os.networking.domain}" = {
        quota = "2G";
        aliases = [
          "abuse@${config.pub-solar-os.networking.domain}"
          "alerts@${config.pub-solar-os.networking.domain}"
          "forgejo@${config.pub-solar-os.networking.domain}"
          "keycloak@${config.pub-solar-os.networking.domain}"
          "mastodon-notifications@${config.pub-solar-os.networking.domain}"
          "matrix@${config.pub-solar-os.networking.domain}"
          "postmaster@${config.pub-solar-os.networking.domain}"
          "nextcloud@${config.pub-solar-os.networking.domain}"
          "no-reply@${config.pub-solar-os.networking.domain}"
          "security@${config.pub-solar-os.networking.domain}"
        ];
      };
      "hakkonaut@${config.pub-solar-os.networking.domain}" = {
        quota = "2G";
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@${config.pub-solar-os.networking.domain}";

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
