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
      # When updating package, remember to update nextcloud31Packages in
      # services.nextcloud.extraApps
      package = pkgs.nextcloud31;
      https = true;
      secretFile = config.age.secrets."nextcloud-secrets".path; # secret
      maxUploadSize = "1G";

      configureRedis = true;

      notify_push = {
        enable = true;
        # Setting this to true breaks Matrix -> NextPush integration because
        # matrix-synapse doesn't like it if cloud.pub.solar resolves to localhost.
        bendDomainToLocalhost = false;
      };

      config = {
        adminuser = "admin";
        adminpassFile = config.age.secrets."nextcloud-admin-pass".path;
        dbuser = "nextcloud";
        dbtype = "pgsql";
        dbname = "nextcloud";
      };

      settings = {
        trusted_proxies = [
          "138.201.80.102"
          "2a01:4f8:172:1c25::1"
        ];
        "overwrite.cli.url" = "https://cloud.${config.pub-solar-os.networking.domain}";
        overwriteprotocol = "https";

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

        enable_previews = true;
        jpeg_quality = 60;
        enabledPreviewProviders = [
          # default from https://github.com/nextcloud/server/blob/master/config/config.sample.php#L1494-L1505
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
          # https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html#previews
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

        # delete all files in the trash bin that are older than 7 days
        # automatically, delete other files anytime if space needed
        trashbin_retention_obligation = "auto,7";
        skeletondirectory = "${pkgs.nextcloud-skeleton}/{lang}";
        defaultapp = "file";
        activity_expire_days = "14";
        updatechecker = false;
        # Valid values are: 0 = Debug, 1 = Info, 2 = Warning, 3 = Error,
        # and 4 = Fatal. Defaults to 2
        loglevel = 2;
        maintenance_window_start = "1";
        "simpleSignUpLink.shown" = false;
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

      # Default config for 4GiB RAM
      # https://docs.nextcloud.com/server/31/admin_manual/installation/server_tuning.html#tune-php-fpm
      poolSettings = {
        pm = "dynamic";
        "pm.max_children" = "120";
        "pm.max_requests" = "500";
        "pm.max_spare_servers" = "18";
        "pm.min_spare_servers" = "6";
        "pm.start_servers" = "12";
      };

      caching.redis = true;
      # Don't allow the installation and updating of apps from the Nextcloud appstore,
      # because we declaratively install them
      appstoreEnable = false;
      autoUpdateApps.enable = false;
      extraApps = {
        inherit (pkgs.nextcloud31Packages.apps)
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
}
