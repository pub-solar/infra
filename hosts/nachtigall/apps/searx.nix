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
    mode = "600";
  };

  services.nginx.virtualHosts."search.pub.solar" = {
    enableACME = true;
    forceSSL = true;

    locations."/".extraConfig = ''
      uwsgi_pass unix:/run/searx/searx.sock;
    '';
  };

  users.users.nginx.extraGroups = [ "searx" ];

  services.searx = {
    enable = true;
    package = pkgs.searxng;
    runInUwsgi = true;

    uwsgiConfig = {
      disable-logging = true;
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
    };

    environmentFile = config.age.secrets.searx-environment.path; 

    settings = {
      use_default_settings = true;

      server = {
        base_url = "https://search.pub.solar";
        secret_key = "@SEARX_SECRET_KEY@";
      };

      general = {
        debug = false;
        instance_name = "search.pub.solar";
        privacypolicy_url = "https://pub.solar/privacy";
        # use true to use your own donation page written in searx/info/en/donate.md
        # use false to disable the donation link
        donation_url = false;
        # mailto:contact@example.com
        contact_url = false;
        enable_metrics = false;
      };

      search = {
        # Existing autocomplete backends: "dbpedia", "duckduckgo", "google", "yandex", "mwmbl",
        # "seznam", "startpage", "swisscows", "qwant", "wikipedia" - leave blank to turn it off
        # by default.
        autocomplete = "duckduckgo";
        # minimun characters to type before autocompleter starts
        autocomplete_min = 4;
      };

      engine = [
        { engine = "startpage"; disabled = false; }
        { engine = "yahoo"; disabled = false; }
        { engine = "tagesschau"; disabled = false; }
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
}
