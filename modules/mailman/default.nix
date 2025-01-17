{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [ 25 ];

  users.users.nginx.extraGroups = [ "mailman" ];

  services.nginx.virtualHosts."list.${config.pub-solar-os.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
  };
  # Tweak permissions so nginx can read and serve the static assets
  # (otherwise /var/lib/mailman-web is mode 0600)
  # https://nixos.wiki/wiki/Mailman
  systemd.services.mailman-settings.script = ''
    chmod o+x /var/lib/mailman-web-static
  '';

  services.postfix = {
    enable = true;
    relayDomains = [ "hash:/var/lib/mailman/data/postfix_domains" ];
    # get TLS certs for list.pub.solar from acme
    sslCert = "/var/lib/acme/list.${config.pub-solar-os.networking.domain}/fullchain.pem";
    sslKey = "/var/lib/acme/list.${config.pub-solar-os.networking.domain}/key.pem";
    config = {
      transport_maps = [ "hash:/var/lib/mailman/data/postfix_lmtp" ];
      local_recipient_maps = [ "hash:/var/lib/mailman/data/postfix_lmtp" ];
    };
    rootAlias = "admins@pub.solar";
    postmasterAlias = "admins@pub.solar";
    hostname = "list.${config.pub-solar-os.networking.domain}";
  };

  systemd.paths.watcher-acme-ssl-file = {
    description = "Watches for changes in acme's TLS cert file (after renewals) to reload postfix";
    documentation = [ "systemd.path(5)" ];
    partOf = [ "postfix-reload.service" ];
    pathConfig = {
      PathChanged = "/var/lib/acme/list.${config.pub-solar-os.networking.domain}/fullchain.pem";
      Unit = "postfix-reload.service";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services."postfix-reload" = {
    description = "Reloads postfix config, e.g. after TLS certs change, notified by watcher-acme-ssl-file.path";
    documentation = [ "systemd.path(5)" ];
    requires = [ "postfix.service" ];
    after = [ "postfix.service" ];
    startLimitIntervalSec = 10;
    startLimitBurst = 5;
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.systemd}/bin/systemctl reload postfix
    '';
    wantedBy = [ "multi-user.target" ];
  };

  services.mailman = {
    enable = true;
    serve.enable = true;
    hyperkitty.enable = true;
    webHosts = [ "list.${config.pub-solar-os.networking.domain}" ];
    siteOwner = "admins@pub.solar";
  };

  # TODO add django-keycloak as auth provider
  # https://django-keycloak.readthedocs.io/en/latest/
  ## Extend settings.py directly since this can't be done via JSON
  ## settings (services.mailman.webSettings)
  #environment.etc."mailman3/settings.py".text = ''
  #  INSTALLED_APPS.extend([
  #    "allauth.socialaccount.providers.github",
  #    "allauth.socialaccount.providers.gitlab"
  #  ])
  #'';

  services.restic.backups.mailman-storagebox = {
    paths = [
      "/var/lib/mailman"
      "/var/lib/mailman-web/mailman-web.db"
      "/var/lib/mailman-web/settings_local.json"
      "/var/lib/postfix/conf/aliases.db"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00 Etc/UTC";
    };
    initialize = true;
    passwordFile = config.age.secrets."restic-repo-storagebox-nachtigall".path;
    repository = "sftp:u377325@u377325.your-storagebox.de:/backups";
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };
}
