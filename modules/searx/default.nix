{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  vHostDomain = "search.${config.pub-solar-os.networking.domain}";
in
{
  age.secrets.searx-environment = {
    file = "${flake.self}/secrets/searx-environment.age";
    mode = "600";
  };

  services.nginx.virtualHosts.${vHostDomain} = {
    enableACME = true;
    forceSSL = true;

    extraConfig = ''
      access_log /var/log/nginx/${vHostDomain}-access.log combined_host;
      error_log /var/log/nginx/${vHostDomain}-error.log;
    '';

    locations."/".extraConfig = ''
      uwsgi_pass unix:/run/searx/searx.sock;
    '';
  };

  users.users.nginx.extraGroups = [ "searx" ];

  services.searx = {
    enable = true;
    package = pkgs.searxng;
    configureUwsgi = true;

    uwsgiConfig = {
      disable-logging = true;
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
    };

    environmentFile = config.age.secrets.searx-environment.path;

    # Block bots so we get suspended less often
    # https://github.com/searxng/searxng/issues/2498#issuecomment-1590625541
    limiterSettings = {
      botdetection.ip_limit.link_token = true;
    };

    faviconsSettings.favicons = {
      cfg_schema = 1;
      cache = {
        db_url = "/var/cache/searx/faviconcache.db";
        HOLD_TIME = 5184000;
        LIMIT_TOTAL_BYTES = 2147483648;
        BLOB_MAX_BYTES = 40960;
        MAINTENANCE_MODE = "auto";
        MAINTENANCE_PERIOD = 600;
      };
    };

    settings = {
      use_default_settings = true;

      server = {
        base_url = "https://search.${config.pub-solar-os.networking.domain}";
        secret_key = "@SEARX_SECRET_KEY@";
        limiter = true;
        public_instance = true;
      };

      valkey.url = "valkey://localhost:6379/0";

      brand.custom.links = {
        About = "https://pub.solar/about";
      };

      general = {
        debug = false;
        instance_name = "search.${config.pub-solar-os.networking.domain}";
        privacypolicy_url = config.pub-solar-os.privacyPolicyUrl;
        # use true to use your own donation page written in searx/info/en/donate.md
        # use false to disable the donation link
        donation_url = "https://pub.solar/about/#donate-via-iban";
        # mailto:contact@example.com
        contact_url = "https://pub.solar/about/#contact-and-getting-help";
        enable_metrics = false;
      };

      search = {
        # Existing autocomplete backends: "dbpedia", "duckduckgo", "google", "yandex", "mwmbl",
        # "seznam", "startpage", "swisscows", "qwant", "wikipedia" - leave blank to turn it off
        # by default.
        autocomplete = "duckduckgo";
        # minimun characters to type before autocompleter starts
        autocomplete_min = 4;
        safe_search = 1; # Moderate

        suspended_times = {
          SearxEngineAccessDenied = 900;
          SearxEngineCaptcha = 86400;
          SearxEngineTooManyRequests = 1800;
          cf_SearxEngineCaptcha = 1296000;
          cf_SearxEngineAccessDenied = 86400;
          recaptcha_SearxEngineCaptcha = 604800;
        };
      };

      engines = [
        {
          name = "qwant";
          engine = "qwant";
          disabled = false;
        }
        {
          name = "bing";
          engine = "bing";
          disabled = false;
        }
        {
          name = "wikidata";
          engine = "wikidata";
          disabled = false;
        }
      ];

      ui = {
        # query_in_title: When true, the result page's titles contains the query
        # it decreases the privacy, since the browser can records the page titles.
        query_in_title = false;
        # infinite_scroll: When true, automatically loads the next page when scrolling to bottom of the current page.
        infinite_scroll = true;
      };
    };
  };

  # Valkey uses uid and gid 999 internally
  # https://github.com/valkey-io/valkey-container/blob/mainline/9.1/debian/Dockerfile#L86-L87
  systemd.tmpfiles.rules = [ "d /var/lib/valkey/searx 0770 999 999 - -" ];

  virtualisation = {
    oci-containers = {
      backend = "docker";

      containers."valkey-searx" = {
        image = "valkey/valkey:9.1.0";
        autoStart = true;
        ports = [ "127.0.0.1:6379:6379" ];

        volumes = [
          "/var/lib/valkey/searx:/data"
        ];

        cmd = [
          "--save 60 1"
          "--loglevel warning"
        ];
      };
    };
  };
}
