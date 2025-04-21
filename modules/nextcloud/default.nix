{
  config,
  pkgs,
  flake,
  lib,
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

    locations = {
      "=/_matrix/push/v1/notify" = {
        extraConfig = ''
          set $custom_request_uri /index.php/apps/uppush/gateway/matrix;
          rewrite ^.*$ /index.php/apps/uppush/gateway/matrix last;
        '';
      };

      # Increase timeouts for unified push
      "^~ /index.php/apps/uppush/" = {
        priority = 499;
        extraConfig = ''
          # this is copy-pasted from nixpkgs
          include ${config.services.nginx.package}/conf/fastcgi.conf;
          fastcgi_split_path_info ^(.+?\.php)(/.*)$;
          set $path_info $fastcgi_path_info;
          try_files $fastcgi_script_name =404;
          fastcgi_param PATH_INFO $path_info;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_param HTTPS ${if config.services.nextcloud.https then "on" else "off"};
          fastcgi_param modHeadersAvailable true;
          fastcgi_param front_controller_active true;

          # Added timeouts for nextpush
          fastcgi_buffering off;
          fastcgi_connect_timeout 10m;
          fastcgi_send_timeout 10m;
          fastcgi_read_timeout 10m;

          # If custom request is not set (ergo not _matrix push) then just keep request_uri
          if ($custom_request_uri ~ "^$") {
              set $custom_request_uri $request_uri;
          }
          # Apply our custom uri
          fastcgi_param REQUEST_URI $custom_request_uri;

          # copied from nixpkgs again
          fastcgi_pass unix:${config.services.phpfpm.pools.nextcloud.socket};
          fastcgi_intercept_errors on;
          fastcgi_request_buffering off;
        '';
      };
    };
  };

  services.nextcloud =
    let
      exiftool_1270 = pkgs.perlPackages.buildPerlPackage rec {
        # NOTE nextcloud-memories needs this specific version of exiftool
        # https://github.com/NixOS/nixpkgs/issues/345267
        pname = "Image-ExifTool";
        version = "12.70";
        src = pkgs.fetchFromGitHub {
          owner = "exiftool";
          repo = "exiftool";
          rev = version;
          hash = "sha256-YMWYPI2SDi3s4KCpSNwovemS5MDj5W9ai0sOkvMa8Zg=";
        };
        nativeBuildInputs = lib.optional pkgs.stdenv.hostPlatform.isDarwin pkgs.shortenPerlShebang;
        postInstall = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
          shortenPerlShebang $out/bin/exiftool
        '';
      };
    in
    {
      hostName = "cloud.${config.pub-solar-os.networking.domain}";
      home = "/var/lib/nextcloud";

      enable = true;
      # When updating package, remember to update nextcloud30Packages in
      # services.nextcloud.extraApps
      package = pkgs.nextcloud30;
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
      };

      settings = {
        overwrite.cli.url = "https://cloud.${config.pub-solar-os.networking.domain}";
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
        jpeg_quality = 60;
        enabledPreviewProviders = [
          "OC\\Preview\\PNG"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\GIF"
          "OC\\Preview\\BMP"
          "OC\\Preview\\HEIC"
          "OC\\Preview\\TIFF"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\SVG"
          "OC\\Preview\\WebP"
          "OC\\Preview\\Font"
          "OC\\Preview\\Movie"
          "OC\\Preview\\ImaginaryPDF"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\Krita"
          "OC\\Preview\\TXT"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\Imaginary"
        ];
        preview_imaginary_url = "http://127.0.0.1:${toString config.services.imaginary.port}/";
        preview_max_filesize_image = 128; # MB
        preview_max_memory = 512; # MB
        preview_max_x = 2048; # px
        preview_max_y = 2048; # px
        preview_max_scale_factor = 1;
        preview_format = "webp";
        "preview_ffmpeg_path" = lib.getExe pkgs.ffmpeg-headless;

        "memories.exiftool_no_local" = false;
        "memories.exiftool" = "${exiftool_1270}/bin/exiftool";
        "memories.vod.ffmpeg" = lib.getExe pkgs.ffmpeg;
        "memories.vod.ffprobe" = lib.getExe' pkgs.ffmpeg-headless "ffprobe";

        auth.bruteforce.protection.enabled = true;
        trashbin_retention_obligation = "auto,7";
        skeletondirectory = "${pkgs.nextcloud-skeleton}/{lang}";
        defaultapp = "file";
        activity_expire_days = "14";
        integrity.check.disabled = false;
        updater.release.channel = "stable";
        loglevel = 0;
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
        # https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html#:~:text=opcache.jit%20%3D%201255%20opcache.jit_buffer_size%20%3D%20128m
        "opcache.jit" = "1255";
        "opcache.jit_buffer_size" = "128M";
        # Ensure that this matches nextcloud's session_lifetime config
        # https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#session-lifetime
        "session.gc_maxlifetime" = "86400";
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
      # Don't allow the installation and updating of apps from the Nextcloud appstore,
      # because we declaratively install them
      appstoreEnable = false;
      autoUpdateApps.enable = false;
      extraApps = {
        inherit (pkgs.nextcloud30Packages.apps)
          calendar
          contacts
          cospend
          deck
          end_to_end_encryption
          groupfolders
          integration_deepl
          mail
          memories
          notes
          notify_push
          previewgenerator
          quota_warning
          recognize
          richdocuments
          spreed
          tasks
          twofactor_webauthn
          uppush
          user_oidc
          ;
      };
      database.createLocally = true;
    };

  # https://docs.nextcloud.com/server/30/admin_manual/installation/server_tuning.html#previews
  services.imaginary = {
    enable = true;
    address = "127.0.0.1";
    settings.return-size = true;
  };

  systemd = {
    services =
      let
        occ = "/run/current-system/sw/bin/nextcloud-occ";
      in
      {
        nextcloud-cron-preview-generator = {
          environment.NEXTCLOUD_CONFIG_DIR = "${config.services.nextcloud.home}/config";
          serviceConfig = {
            ExecStart = "${occ} preview:pre-generate";
            Type = "oneshot";
            User = "nextcloud";
          };
        };

        nextcloud-preview-generator-setup = {
          wantedBy = [ "multi-user.target" ];
          requires = [ "phpfpm-nextcloud.service" ];
          after = [ "phpfpm-nextcloud.service" ];
          environment.NEXTCLOUD_CONFIG_DIR = "${config.services.nextcloud.home}/config";
          script = # bash
            ''
              # check with:
              # for size in squareSizes widthSizes heightSizes; do echo -n "$size: "; nextcloud-occ config:app:get previewgenerator $size; done

              # extra commands run for preview generator:
              # 32   icon file list
              # 64   icon file list android app, photos app
              # 96   nextcloud client VFS windows file preview
              # 256  file app grid view, many requests
              # 512  photos app tags
              ${occ} config:app:set --value="32 64 96 256 512" previewgenerator squareSizes

              # 341 hover in maps app
              # 1920 files/photos app when viewing picture
              ${occ} config:app:set --value="341 1920" previewgenerator widthSizes

              # 256 hover in maps app
              # 1080 files/photos app when viewing picture
              ${occ} config:app:set --value="256 1080" previewgenerator heightSizes
            '';
          serviceConfig = {
            Type = "oneshot";
            User = "nextcloud";
          };
        };
      };
    timers.nextcloud-cron-preview-generator = {
      after = [ "nextcloud-setup.service" ];
      timerConfig = {
        OnCalendar = "*:0/10";
        OnUnitActiveSec = "9m";
        Persistent = true;
        RandomizedDelaySec = 60;
        Unit = "nextcloud-cron-preview-generator.service";
      };
      wantedBy = [ "timers.target" ];
    };
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
  };
}
