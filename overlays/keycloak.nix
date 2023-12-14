final: prev: {
  keycloak = prev.keycloak.overrideAttrs (oldAttrs: rec {
    version = "999.0.0-SNAPSHOT";
    src = prev.fetchzip {
      url = "https://github.com/keycloak/keycloak/releases/download/nightly/keycloak-${version}.zip";
      hash = "sha256-2rOhBmPXQy6HK3CtG/7E2EUK5zEWrJtSgBg6AMw2q3E=";
    };
  });
}
