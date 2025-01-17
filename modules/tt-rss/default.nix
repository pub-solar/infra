{
  flake,
  config,
  pkgs,
  ...
}:
let
  ttrss-auth-oidc = pkgs.stdenv.mkDerivation {
    name = "ttrss-auth-oidc";
    version = "7ebfbc91e92bb133beb907c6bde79279ee5156df";
    src = pkgs.fetchgit {
      url = "https://git.tt-rss.org/fox/ttrss-auth-oidc.git";
      rev = "7ebfbc91e92bb133beb907c6bde79279ee5156df";
      hash = "sha256-G6vZBvSWms6s6nHZWsxJjMGuubt/imiBvbp6ykwrZbg=";
    };
    installPhase = ''
      mkdir -p $out/auth_oidc
      cp -r * $out/auth_oidc
    '';
  };
in
{
  age.secrets.tt-rss-database-password = {
    file = "${flake.self}/secrets/tt-rss-database-password.age";
    owner = "tt_rss";
    mode = "600";
  };
  age.secrets.tt-rss-keycloak-client-secret = {
    file = "${flake.self}/secrets/tt-rss-keycloak-client-secret.age";
    owner = "tt_rss";
    mode = "600";
  };
  age.secrets.tt-rss-smtp-password = {
    file = "${flake.self}/secrets/tt-rss-smtp-password.age";
    owner = "tt_rss";
    mode = "600";
  };
  age.secrets.tt-rss-feed-crypt-key = {
    file = "${flake.self}/secrets/tt-rss-feed-crypt-key.age";
    owner = "tt_rss";
    mode = "600";
  };

  services.nginx.virtualHosts."rss.${config.pub-solar-os.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
  };

  services.tt-rss = {
    enable = true;
    virtualHost = "rss.${config.pub-solar-os.networking.domain}";
    selfUrlPath = "https://rss.${config.pub-solar-os.networking.domain}";
    root = "/var/lib/tt-rss";
    logDestination = "";
    plugins = [
      "auth_internal"
      "note"
      "auth_oidc"
    ];
    pluginPackages = [ ttrss-auth-oidc ];
    email = {
      server = "mail.pub.solar";
      security = "tls";
      login = "admins@pub.solar";
      fromName = "pub.solar RSS server";
      fromAddress = "rss@pub.solar";
      digestSubject = "[RSS] New headlines for last 24 hours";
    };
    database = {
      passwordFile = config.age.secrets.tt-rss-database-password.path;
      createLocally = true;
    };
    extraConfig = ''
      putenv('TTRSS_SMTP_PASSWORD=' . file_get_contents('${config.age.secrets.tt-rss-smtp-password.path}'));
      putenv('TTRSS_AUTH_OIDC_NAME=pub.solar ID');
      putenv('TTRSS_AUTH_OIDC_URL=https://auth.${config.pub-solar-os.networking.domain}/realms/${config.pub-solar-os.auth.realm}/');
      putenv('TTRSS_AUTH_OIDC_CLIENT_ID=tt-rss');
      putenv('TTRSS_AUTH_OIDC_CLIENT_SECRET=' . file_get_contents('${config.age.secrets.tt-rss-keycloak-client-secret.path}'));
      putenv('TTRSS_FEED_CRYPT_KEY=' . file_get_contents('${config.age.secrets.tt-rss-feed-crypt-key.path}'));
    '';
  };
}
