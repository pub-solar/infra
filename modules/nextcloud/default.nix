{
  config,
  pkgs,
  flake,
  ...
}:
{
  age.secrets."nextcloud-secrets" = {
    file = "${flake.self}/secrets/nextcloud-secrets.age";
    mode = "400";
    owner = "nextcloud";
  };

  age.secrets."nextcloud-admin-pass" = {
    file = "${flake.self}/secrets/nextcloud-admin-pass.age";
    mode = "400";
    owner = "nextcloud";
  };

  services.nginx.virtualHosts."cloud.${config.pub-solar-os.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
  };

  services.nextcloud = {
    hostName = "cloud.${config.pub-solar-os.networking.domain}";
    home = "/var/lib/nextcloud";

    enable = true;
    package = pkgs.nextcloud29;
    https = true;
    secretFile = config.age.secrets."nextcloud-secrets".path; # secret
    maxUploadSize = "1G";

    configureRedis = true;

    notify_push = {
      enable = true;
      bendDomainToLocalhost = true;
    };

    config = {
      adminuser = "admin";
      adminpassFile = config.age.secrets."nextcloud-admin-pass".path;
      dbuser = "nextcloud";
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbtableprefix = "oc_";
    };

    settings = {
      overwrite.cli.url = "http://cloud.${config.pub-solar-os.networking.domain}";
      overwriteprotocol = "https";

      installed = true;
      default_phone_region = "+49";
      mail_sendmailmode = "smtp";
      mail_from_address = "nextcloud";
      mail_smtpmode = "smtp";
      mail_smtpauthtype = "PLAIN";
      mail_domain = "pub.solar";
      mail_smtpname = "admins@pub.solar";
      mail_smtpsecure = "ssl";
      mail_smtpauth = true;
      mail_smtphost = "mail.pub.solar";
      mail_smtpport = "465";

      # This is to allow connections to collabora and keycloak, among other services
      # running on the same host
      #
      # https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/config_sample_php_parameters.html?highlight=allow_local_remote_servers%20true
      # https://github.com/ONLYOFFICE/onlyoffice-nextcloud/issues/293
      allow_local_remote_servers = true;

      enable_previews = true;
      enabledPreviewProviders = [
        "OC\\Preview\\PNG"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\GIF"
        "OC\\Preview\\BMP"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\Movie"
        "OC\\Preview\\PDF"
        "OC\\Preview\\MP3"
        "OC\\Preview\\TXT"
        "OC\\Preview\\MarkDown"
      ];
      preview_max_x = "1024";
      preview_max_y = "768";
      preview_max_scale_factor = "1";

      auth.bruteforce.protection.enabled = true;
      trashbin_retention_obligation = "auto,7";
      skeletondirectory = "./nextcloud-skeleton";
      defaultapp = "file";
      activity_expire_days = "14";
      integrity.check.disabled = false;
      updater.release.channel = "stable";
      loglevel = 2;
      debug = false;
      maintenance_window_start = "1";
      # maintenance = false;
      app_install_overwrite = [
        "pdfdraw"
        "integration_whiteboard"
      ];
      htaccess.RewriteBase = "/";
      theme = "";
      simpleSignUpLink.shown = false;
    };

    phpOptions = {
      "opcache.interned_strings_buffer" = "32";
      "opcache.max_accelerated_files" = "16229";
      "opcache.memory_consumption" = "256";
      # https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html#enable-php-opcache
      "opcache.revalidate_freq" = "60";
      # https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html#:~:text=opcache.jit%20%3D%201255%20opcache.jit_buffer_size%20%3D%20128m
      "opcache.jit" = "1255";
      "opcache.jit_buffer_size" = "128M";
    };

    # Calculated with 4GiB RAM, 80MiB process size available on
    # https://spot13.com/pmcalculator/
    poolSettings = {
      pm = "dynamic";
      "pm.max_children" = "52";
      "pm.max_requests" = "500";
      "pm.max_spare_servers" = "39";
      "pm.min_spare_servers" = "13";
      "pm.start_servers" = "13";
    };

    caching.redis = true;
    autoUpdateApps.enable = true;
    database.createLocally = true;
  };

  services.restic.backups.nextcloud-storagebox = {
    paths = [
      "/var/lib/nextcloud/data"
      "/tmp/nextcloud-backup.sql"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00 Etc/UTC";
    };
    initialize = true;
    passwordFile = config.age.secrets."restic-repo-storagebox-nachtigall".path;
    repository = "sftp:u377325@u377325.your-storagebox.de:/backups";
    backupPrepareCommand = ''
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d nextcloud > /tmp/nextcloud-backup.sql
    '';
    backupCleanupCommand = ''
      rm /tmp/nextcloud-backup.sql
    '';
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };
}
