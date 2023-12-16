let
  # set ssh public keys here for your system and user
  axeman-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNeQYLFauAbzDyIbKC86NUh9yZfiyBm/BtIdkcpZnSU axeman@tuxnix";
  b12f-bbcom = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmXpOU6vzQiVSSYCoxHYv7wDxC63Qg3dxlAMR6AOzwIABCU5PFFNcO0NWYms/YR7MOViorl+19LCLRABar9JgHU1n+uqxKV6eGph3OPeMp5sN8LAh7C9N+TZj8iJzBxQ3ch+Z/LdmLRwYNJ7KSUI+gwGK6xRS3+z1022Y4P0G0sx7IeCBl4lealQEIIF10ZOfjUdBcLQar7XTc5AxyGKnHCerXHRtccCoadLQujk0AvPXbv3Ma4JwX9X++AnCWRWakqS5UInu2tGuZ/6Hrjd2a9AKWjTaBVDcbYqCvY4XVuMj2/A2bCceFBaoi41apybSk26FSFTU4qiEUNQ6lxeOwG4+1NCXyHe2bGI4VyoxinDYa8vLLzXIRfTRA0qoGfCweXNeWPf0jMqASkUKaSOH5Ot7O5ps34r0j9pWzavDid8QeKJPyhxKuF1a5G4iBEZ0O9vuti60dPSjJPci9oTxbune2/jb7Sa0yO06DtLFJ2ncr5f70s/BDxKk4XIwQLy+KsvzlQEGdY8yA6xv28bOGxL3sQ0HE2pDTsvIbAisVOKzdJeolStL9MM5W8Hg0r/KkGj2bg0TfoRp1xHV9hjKkvJrsQ6okaPvNFeZq0HXzPhWMOVQ+/46z80uaQ1ByRLr3FTwuWJ7F/73ndfxiq6bDE4z2Ji0vOjeWJm6HCxTdGw== hello@benjaminbaedorf.com";
  hensoko-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbaQdxp7Flz6ttELe63rn+Nt9g43qJOLih6VCMP4gPb";
  hensoko-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqkqMYgncrnczcW/0PY+Z+FmNXXpgw6D9JWTTwiainy";
  teutat3s-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcU6KPy4b1MQXd6EJhcYwbJu7E+0IrBZF/IP6T7gbMf teutat3s@dumpyourvms";

  nachtigall-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7G0ufi+MNvaAZLDgpieHrABPGN7e/kD5kMFwSk4ABj root@nachtigall";
  flora-6-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGP1InpTBN4AlF/4V8HHumAMLJzeO8DpzjUv9Co/+J09 root@flora-6";

  baseKeys = [
    axeman-1
    b12f-bbcom
    hensoko-1
    hensoko-2
    teutat3s-1
  ];

  nachtigallKeys = [
    nachtigall-host
  ];

  flora6Keys = [
    flora-6-host
  ];
in {
  # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBB5XaH02a6+TchnyQED2VwaltPgeFCbildbE2h6nF5e root@nachtigall
  "nachtigall-root-ssh-key.age".publicKeys = nachtigallKeys ++ baseKeys;

  "mastodon-secret-key-base.age".publicKeys = nachtigallKeys ++ baseKeys;
  "mastodon-otp-secret.age".publicKeys = nachtigallKeys ++ baseKeys;
  "mastodon-vapid-private-key.age".publicKeys = nachtigallKeys ++ baseKeys;
  "mastodon-vapid-public-key.age".publicKeys = nachtigallKeys ++ baseKeys;
  "mastodon-smtp-password.age".publicKeys = nachtigallKeys ++ baseKeys;
  "mastodon-extra-env-secrets.age".publicKeys = nachtigallKeys ++ baseKeys;

  "keycloak-database-password.age".publicKeys = nachtigallKeys ++ baseKeys;

  "forgejo-actions-runner-token.age".publicKeys = flora6Keys ++ baseKeys;
  "forgejo-database-password.age".publicKeys = nachtigallKeys ++ baseKeys;
  "forgejo-mailer-password.age".publicKeys = nachtigallKeys ++ baseKeys;

  "matrix-mautrix-telegram-env-file.age".publicKeys = nachtigallKeys ++ baseKeys;
  "matrix-synapse-signing-key.age".publicKeys = nachtigallKeys ++ baseKeys;
  "matrix-synapse-secret-config.yaml.age".publicKeys = nachtigallKeys ++ baseKeys;
  "matrix-synapse-sliding-sync-secret.age".publicKeys = nachtigallKeys ++ baseKeys;

  "nextcloud-secrets.age".publicKeys = nachtigallKeys ++ baseKeys;
  "nextcloud-admin-pass.age".publicKeys = nachtigallKeys ++ baseKeys;

  "searx-environment.age".publicKeys = nachtigallKeys ++ baseKeys;

  "restic-repo-droppie.age".publicKeys = nachtigallKeys ++ baseKeys;
  "restic-repo-storagebox.age".publicKeys = nachtigallKeys ++ baseKeys;

  "drone-db-secrets.age".publicKeys = flora6Keys ++ baseKeys;
  "drone-secrets.age".publicKeys = flora6Keys ++ baseKeys;

  "mediawiki-database-password.age".publicKeys = nachtigallKeys ++ baseKeys;
  "mediawiki-admin-password.age".publicKeys = nachtigallKeys ++ baseKeys;
  "mediawiki-oidc-client-secret.age".publicKeys = nachtigallKeys ++ baseKeys;
  "mediawiki-secret-key.age".publicKeys = nachtigallKeys ++ baseKeys;

  "coturn-static-auth-secret.age".publicKeys = nachtigallKeys ++ baseKeys;

  "grafana-admin-password.age".publicKeys = flora6Keys ++ baseKeys;
  "grafana-keycloak-client-secret.age".publicKeys = flora6Keys ++ baseKeys;
  "grafana-smtp-password.age".publicKeys = flora6Keys ++ baseKeys;

  "nachtigall-metrics-nginx-basic-auth.age".publicKeys = nachtigallKeys ++ baseKeys;
  "nachtigall-metrics-prometheus-basic-auth-password.age".publicKeys = flora6Keys ++ nachtigallKeys ++ baseKeys;
}
