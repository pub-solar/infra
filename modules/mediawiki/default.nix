{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  localSettingsPHP = pkgs.writeScript "LocalSettings.php" ''
    <?php
      # Protect against web entry
      if ( !defined( 'MEDIAWIKI' ) ) {
        exit;
      }

      # error_reporting( -1 );
      # ini_set( 'display_errors', 1 );
      # $wgShowExceptionDetails = true;
      # $wgDBerrorLog = '/dev/stderr';
      # $wgDebugLogFile = "/dev/stderr";

      $wgSitename = "pub.solar wiki";
      $wgMetaNamespace = false;

      ## The URL base path to the directory containing the wiki;
      ## defaults for all runtime URL paths are based off of this.
      ## For more information on customizing the URLs
      ## (like /w/index.php/Page_title to /wiki/Page_title) please see:
      ## https://www.mediawiki.org/wiki/Manual:Short_URL
      $wgScriptPath = "https://wiki.${config.pub-solar-os.networking.domain}";

      ## https://www.mediawiki.org/wiki/Manual:Short_URL
      ## https://www.mediawiki.org/wiki/Extension:OpenID_Connect#Known_issues
      $wgArticlePath = "/index.php/$1";

      ## The protocol and server name to use in fully-qualified URLs
      $wgServer = "https://wiki.${config.pub-solar-os.networking.domain}";

      ## The URL path to static resources (images, scripts, etc.)
      $wgResourceBasePath = $wgScriptPath;

      ## The URL path to the logo.  Make sure you change this from the default,
      ## or else you'll overwrite your logo when you upgrade!
      $wgLogo = "https://pub.solar/assets/pubsolar.svg";

      ## UPO means: this is also a user preference option

      $wgEnableEmail = true;
      $wgEnableUserEmail = true; # UPO

      $wgPasswordSender = "admins@pub.solar";

      $wgEnotifUserTalk = false; # UPO
      $wgEnotifWatchlist = false; # UPO
      $wgEmailAuthentication = true;

      ## Database settings
      $wgDBtype = "postgres";
      $wgDBserver = "host.docker.internal";
      $wgDBport = "5432";
      $wgDBname = "mediawiki";
      $wgDBuser = "mediawiki";
      $wgDBpassword = trim(file_get_contents("/run/mediawiki/database-password"));

      ## Shared memory settings
      $wgMainCacheType = CACHE_NONE;
      $wgMemCachedServers = [];

      $wgEnableUploads = true;
      $wgUploadDirectory = "/var/www/html/uploads";
      $wgUploadPath = $wgScriptPath . "/uploads";

      $wgFileExtensions = [ 'png', 'gif', 'jpg', 'jpeg', 'webp', 'svg', 'pdf', ];

      $wgUseImageMagick = true;
      $wgImageMagickConvertCommand = "/usr/bin/convert";

      # InstantCommons allows wiki to use images from https://commons.wikimedia.org
      $wgUseInstantCommons = true;

      # Periodically send a pingback to https://www.mediawiki.org/ with basic data
      # about this MediaWiki instance. The Wikimedia Foundation shares this data
      # with MediaWiki developers to help guide future development efforts.
      $wgPingback = true;

      ## If you use ImageMagick (or any other shell command) on a
      ## Linux server, this will need to be set to the name of an
      ## available UTF-8 locale
      $wgShellLocale = "C.UTF-8";

      # Site language code, should be one of the list in ./languages/data/Names.php
      $wgLanguageCode = "en";

      $wgSecretKey = trim(file_get_contents("/run/mediawiki/secret-key"));

      # Changing this will log out all existing sessions.
      $wgAuthenticationTokenVersion = "";

      ## For attaching licensing metadata to pages, and displaying an
      ## appropriate copyright notice / icon. GNU Free Documentation
      ## License and Creative Commons licenses are supported so far.
      $wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
      $wgRightsUrl = "";
      $wgRightsText = "";
      $wgRightsIcon = "";

      # Path to the GNU diff3 utility. Used for conflict resolution.
      $wgDiff = "/usr/bin/diff";
      $wgDiff3 = "/usr/bin/diff3";

      # Enabled skins.
      wfLoadSkin('MonoBook');
      wfLoadSkin('Timeless');
      wfLoadSkin('Vector');

      # Enabled extensions.
      wfLoadExtension('OpenIDConnect');
      wfLoadExtension('PluggableAuth');
      wfLoadExtension('VisualEditor');
      wfLoadExtension('TemplateStyles');

      # End of automatically generated settings.
      # Add more configuration options below.

      $wgLogos = [
        'svg' => "https://pub.solar/assets/pubsolar.svg",
        'icon' => "https://pub.solar/assets/pubsolar.svg",
        'wordmark' => [
          'src'=> "https://pub.solar/assets/pubsolar.svg",
          'width'=> 0,
          'height'=> 0,
        ],
      ];
      $wgFavicon = 'https://pub.solar/assets/pubsolar.svg';

      $wgDefaultSkin = 'vector-2022';

      // https://www.mediawiki.org/wiki/Extension:PluggableAuth#Installation
      $wgGroupPermissions['*']['autocreateaccount'] = true;

      // https://www.mediawiki.org/wiki/Extension:PluggableAuth#Configuration
      $wgPluggableAuth_EnableAutoLogin = false;
      $wgPluggableAuth_ButtonLabel = 'Login with pub.solar ID';
      // Avoid getting logged out after 30 minutes
      // https://www.mediawiki.org/wiki/Topic:W4be4h6t63vf3y8p
      // https://www.mediawiki.org/wiki/Manual:$wgRememberMe
      $wgRememberMe = 'always';

      // https://www.mediawiki.org/wiki/Extension:OpenID_Connect#Keycloak
      $wgPluggableAuth_Config[] = [
          'plugin' => 'OpenIDConnect',
          'data' => [
              'providerURL' => 'https://auth.${config.pub-solar-os.networking.domain}/realms/${config.pub-solar-os.auth.realm}',
              'clientID' => 'mediawiki',
              'clientsecret' => trim(file_get_contents('/run/mediawiki/oidc-client-secret'))
          ]
      ];
      $wgOpenIDConnect_SingleLogout = true;
      $wgOpenIDConnect_MigrateUsersByEmail = true;
  '';

  uid = 986;
  gid = 984;
in
{
  age.secrets.mediawiki-database-password = {
    file = "${flake.self}/secrets/mediawiki-database-password.age";
    path = "/run/mediawiki/database-password";
    symlink = false;
    mode = "440";
    owner = "mediawiki";
    group = "mediawiki";
  };

  age.secrets.mediawiki-oidc-client-secret = {
    file = "${flake.self}/secrets/mediawiki-oidc-client-secret.age";
    path = "/run/mediawiki/oidc-client-secret";
    symlink = false;
    mode = "440";
    owner = "mediawiki";
    group = "mediawiki";
  };

  age.secrets.mediawiki-secret-key = {
    file = "${flake.self}/secrets/mediawiki-secret-key.age";
    path = "/run/mediawiki/secret-key";
    symlink = false;
    mode = "440";
    owner = "mediawiki";
    group = "mediawiki";
  };

  services.postgresql = {
    authentication = ''
      host mediawiki all 172.17.0.0/16 password
    '';
  };

  services.nginx.virtualHosts."wiki.${config.pub-solar-os.networking.domain}" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://127.0.0.1:8293";
  };

  users.users.mediawiki = {
    isSystemUser = true;
    group = "mediawiki";
    inherit uid;
  };
  users.groups.mediawiki = {
    inherit gid;
  };

  virtualisation = {
    oci-containers = {
      backend = "docker";

      containers."mediawiki" = {
        image = "git.pub.solar/pub-solar/mediawiki-oidc-docker:1.43.1";
        user = "1000:${builtins.toString gid}";
        autoStart = true;

        ports = [ "127.0.0.1:8293:80" ];

        extraOptions = [
          "--add-host=host.docker.internal:host-gateway"
          "--pull=always"
        ];

        volumes = [
          "/run/mediawiki:/run/mediawiki"
          "/var/lib/mediawiki/images:/var/www/html/images"
          "/var/lib/mediawiki/uploads:/var/www/html/uploads"
          "/var/lib/mediawiki/logs:/var/log/mediawiki"
          "${localSettingsPHP}:/var/www/html/LocalSettings.php"
        ];
      };
    };
  };

  pub-solar-os.backups.restic.mediawiki = {
    paths = [
      "/var/lib/mediawiki/images"
      "/var/lib/mediawiki/uploads"
      "/tmp/mediawiki-backup.sql"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 00:00:00 Etc/UTC";
    };
    initialize = true;
    backupPrepareCommand = ''
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d mediawiki > /tmp/mediawiki-backup.sql
    '';
    backupCleanupCommand = ''
      rm /tmp/mediawiki-backup.sql
    '';
  };
}
