{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  imports = [
    "${flake.inputs.codeberg-pages}/nixos/modules/services/web-apps/codeberg-pages.nix"
    ./haproxy.nix
  ];

  disabledModules = [
    "/nixos/modules/services/web-apps/codeberg-pages.nix"
  ];

  options.pub-solar-os.codeberg-pages = with lib; {
    enable = mkEnableOption "Enable codeberg-pages server with haproxy. Expects port 80 + 443 to be available for haproxy";

    domain = mkOption {
      description = "Main domain for pages";
      type = types.str;
      default = "lunar.page";
    };

    envfile = mkOption {
      description = "Path to envfile with secrets";
      type = types.str;
    };

    dns-provider = mkOption {
      description = "Code of the ACME DNS provider for the main domain wildcard. See https://go-acme.github.io/lego/dns/ for available values & additional environment variables.";
      type = types.str;
      default = "namecheap";
    };

    http-port = mkOption {
      description = "Listening port for HTTP-01 challenges, haproxy will redirect here from port 80. Defaults to port 8081";
      type = types.str;
      default = "8081";
    };

    host = mkOption {
      description = "Listening address for pages-server";
      type = types.str;
      default = "127.0.0.1";
    };

    port = mkOption {
      description = "Listening port for pages-server";
      type = types.str;
      default = "3443";
    };
  };

  config = lib.mkIf config.pub-solar-os.codeberg-pages.enable {
    services.codeberg-pages = {
      enable = true;
      environmentFile = config.pub-solar-os.codeberg-pages.envfile;
      settings = {
        ACME_ACCEPT_TERMS = "true";
        # haproxy needs to listen on port 443 and port 80
        # acme for domains hosted on this server should use DNS challenges for certificates
        # for custom domain support, HTTP-01 challenges will be forwarded from haproxy port 80 to pages-server HTTP_PORT
        # pages-server takes care of redirecting all requests from http -> https
        ENABLE_HTTP_SERVER = "true";
        HTTP_PORT = config.pub-solar-os.codeberg-pages.http-port;
        ACME_EMAIL = config.pub-solar-os.adminEmail;
        DNS_PROVIDER = config.pub-solar-os.codeberg-pages.dns-provider;
        PAGES_DOMAIN = config.pub-solar-os.codeberg-pages.domain;
        RAW_DOMAIN = "raw.${config.pub-solar-os.codeberg-pages.domain}";
        USE_PROXY_PROTOCOL = "true";

        HOST = config.pub-solar-os.codeberg-pages.host;
        PORT = config.pub-solar-os.codeberg-pages.port;

        GITEA_ROOT = "https://git.${config.pub-solar-os.networking.domain}";
      };
    };
  };
}
