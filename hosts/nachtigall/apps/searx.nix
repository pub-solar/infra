{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
{
  age.secrets.searx-environment = {
    file = "${flake.self}/secrets/searx-environment.age";
    mode = "700";
  };

  services.nginx.virtualHosts."search.pub.solar" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://unix:/run/searx/searx.socket";
  };

  users.users.nginx.extraGroups = [ "searx" ];

  services.searx = {
    enable = true;
    runInUwsgi = true;
    package = searxng;

    uwsgiConfig = {
      disable-logging = true;
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
    };

    environmentFile = config.age.secrets.searx-environment.path; 

    settings = {
      use_default_settings: true;
      server.secret_key = "@SEARX_SECRET_KEY@";

      general = {
        instance_name = "search.pub.solar";
        privacypolicy_url: "https://pub.solar/privacy";
        # use true to use your own donation page written in searx/info/en/donate.md
        # use false to disable the donation link
        donation_url: false
        # mailto:contact@example.com
        contact_url: false
        enable_metrics: false
      };

      search = {
        # Existing autocomplete backends: "dbpedia", "duckduckgo", "google", "yandex", "mwmbl",
        # "seznam", "startpage", "swisscows", "qwant", "wikipedia" - leave blank to turn it off
        # by default.
        autocomplete: "duckduckgo"
        # minimun characters to type before autocompleter starts
        autocomplete_min: 4
      };

      ui = {
        # query_in_title: When true, the result page's titles contains the query
        # it decreases the privacy, since the browser can records the page titles.
        query_in_title = false;
        # infinite_scroll: When true, automatically loads the next page when scrolling to bottom of the current page.
        infinite_scroll = false;
      };
    };
  };
}
