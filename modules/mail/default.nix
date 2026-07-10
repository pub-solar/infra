{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Enable ACME HTTP-01 challenge with nginx
  services.nginx = {
    enable = true;
    virtualHosts.${config.mailserver.fqdn}.enableACME = true;
  };

  mailserver = {
    enable = true;
    stateVersion = lib.mkDefault 3;
    fqdn = "mail.${config.pub-solar-os.networking.domain}";
    domains = [ config.pub-solar-os.networking.domain ];
    # Reference the existing ACME configuration created by nginx
    x509.useACMEHost = config.mailserver.fqdn;

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -R11 -m bcrypt'
    accounts = {
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

    # Don't store indices along with emails
    indexDir = "/var/lib/dovecot/indices";
    fullTextSearch = {
      enable = true;
      # index new email as they arrive
      autoIndex = true;
    };
  };

  # Required for o+x / 755 permissions on /var/lib/dovecot, used in mailserver.indexDir
  systemd.services.dovecot.serviceConfig.StateDirectory = "dovecot";

  security.acme.acceptTerms = true;
  security.acme.defaults.email = config.pub-solar-os.adminEmail;

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
