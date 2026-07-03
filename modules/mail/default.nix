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

  # Workaround for M$ still using a digicert certificate that was distrusted
  # in cacert version v3.123
  # [mailop] Microsoft MX uses distrusted DigiCert Global Root CA
  # test with:
  # openssl s_client -connect omm-com.mail.protection.outlook.com:25 -starttls smtp
  services.postfix.settings.main.smtp_tls_CAfile =
    let
      cacert = pkgs.cacert.overrideAttrs (old: {
        patches = old.patches or [ ] ++ [
          # Partial revert of https://phabricator.services.mozilla.com/D288391 and just enough to work around Microsoft Outlook CA fuckup:
          # https://techcommunity.microsoft.com/blog/exchange/trust-digicert-global-root-g2-certificate-authority-to-avoid-exchange-online-ema/4488311
          (pkgs.writeText "Microsoft-Outlook-DigiCert-Global-Root-CA-2006.patch" ''
            diff --git a/certdata.txt b/certdata.txt
            index 97b118f68..13c4ad771 100644
            --- a/certdata.txt
            +++ b/certdata.txt
            @@ -1740,7 +1740,7 @@ CKA_SERIAL_NUMBER MULTILINE_OCTAL
             \002\020\010\073\340\126\220\102\106\261\241\165\152\311\131\221
             \307\112
             END
            -CKA_TRUST_SERVER_AUTH CK_TRUST CKT_NSS_MUST_VERIFY_TRUST
            +CKA_TRUST_SERVER_AUTH CK_TRUST CKT_NSS_TRUSTED_DELEGATOR
             CKA_TRUST_EMAIL_PROTECTION CK_TRUST CKT_NSS_TRUSTED_DELEGATOR
             CKA_TRUST_CODE_SIGNING CK_TRUST CKT_NSS_MUST_VERIFY_TRUST
             CKA_TRUST_STEP_UP_APPROVED CK_BBOOL CK_FALSE
          '')
        ];
      });
      cacertPackage = cacert.override {
        blacklist = config.security.pki.caCertificateBlacklist;
        extraCertificateFiles = config.security.pki.certificateFiles;
        extraCertificateStrings = config.security.pki.certificates;
      };
    in
    "${cacertPackage}/etc/ssl/certs/ca-bundle.crt";

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
