{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
let
  pagesDomain = "lunar.page";
in
{
  imports = [
    "${flake.inputs.codeberg-pages}/nixos/modules/services/web-apps/codeberg-pages.nix"
    ./haproxy.nix
  ];

  disabledModules = [
    "/nixos/modules/services/web-apps/codeberg-pages.nix"
  ];

  age.secrets.codeberg-pages-envfile = {
    file = "${flake.self}/secrets/codeberg-pages-envfile.age";
    mode = "400";
    owner = "codeberg-pages";
  };

  services.codeberg-pages = {
    enable = true;
    environmentFile = config.age.secrets.codeberg-pages-envfile.path;
    settings = {
      ACME_ACCEPT_TERMS = "true";
      # Nginx on trinkgenossin uses port 80 for ACME http-0 challenges
      ENABLE_HTTP_SERVER = "false";
      ACME_EMAIL = config.pub-solar-os.adminEmail;
      DNS_PROVIDER = "namecheap";
      PAGES_DOMAIN = pagesDomain;
      RAW_DOMAIN = "raw.${pagesDomain}";
      USE_PROXY_PROTOCOL = "true";

      HOST = "127.0.0.1";
      PORT = "3443";

      GITEA_ROOT = "https://git.pub.solar";
    };
  };
}
