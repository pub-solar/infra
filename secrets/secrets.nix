let
  admins = import ../logins/admins.nix;

  nachtigall-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7G0ufi+MNvaAZLDgpieHrABPGN7e/kD5kMFwSk4ABj root@nachtigall";
  metronom-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICLX6UvvrKALKL0xsNnytLPHryzZF5evUnxAgGokf14i root@metronom";
  tankstelle-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdF6cJKPDiloWiDja1ZtqkXDdXOCHPs10HD+JMzgeU4 root@tankstelle";
  trinkgenossin-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZXRDpom/LtyoCxvRuoONARKxIT6wNUwEyUjzHRE7DG root@trinkgenossin";
  delite-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKo7zlfQhcJ5/okFTOoOstZtmEL1iNlHxQ4q2baEcWT root@delite";
  blue-shell-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9g9X0a/MaVtbh44IeLxcq+McuYec0GYAdLsseBpk5f root@blue-shell";
  underground-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGF3PtA89yhVkmN7aJI6gqXK8DW9L7kI71IgiK4TAEwI root@underground";

  adminKeys = builtins.foldl' (
    keys: login: keys ++ (builtins.attrValues login.secretEncryptionKeys)
  ) [ ] (builtins.attrValues admins);

  nachtigallKeys = [ nachtigall-host ];

  tankstelleKeys = [ tankstelle-host ];

  metronomKeys = [ metronom-host ];

  trinkgenossinKeys = [ trinkgenossin-host ];

  deliteKeys = [ delite-host ];

  blueshellKeys = [ blue-shell-host ];

  undergroundKeys = [ underground-host ];

  garageKeys = [
    trinkgenossin-host
    delite-host
    blue-shell-host
  ];
in
{
  # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBB5XaH02a6+TchnyQED2VwaltPgeFCbildbE2h6nF5e root@nachtigall
  "nachtigall-root-ssh-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDeKXqbhNzbXk15h2k8wGBByxMDCC6HE1/fwa4j6ECu root@metronom
  "metronom-root-ssh-key.age".publicKeys = metronomKeys ++ adminKeys;

  "nachtigall-wg-private-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "tankstelle-wg-private-key.age".publicKeys = tankstelleKeys ++ adminKeys;
  "metronom-wg-private-key.age".publicKeys = metronomKeys ++ adminKeys;
  "trinkgenossin-wg-private-key.age".publicKeys = trinkgenossinKeys ++ adminKeys;
  "delite-wg-private-key.age".publicKeys = deliteKeys ++ adminKeys;
  "blue-shell-wg-private-key.age".publicKeys = blueshellKeys ++ adminKeys;

  "mastodon-active-record-encryption-deterministic-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-active-record-encryption-key-derivation-salt.age".publicKeys =
    nachtigallKeys ++ adminKeys;
  "mastodon-active-record-encryption-primary-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-secret-key-base.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-otp-secret.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-vapid-private-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-vapid-public-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-smtp-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-extra-env-secrets.age".publicKeys = nachtigallKeys ++ adminKeys;

  "keycloak-database-password.age".publicKeys = nachtigallKeys ++ adminKeys;

  "keycloak-admin-cli-client-secret.age".publicKeys = nachtigallKeys ++ adminKeys;
  "matrix-admin-access-token.age".publicKeys = nachtigallKeys ++ adminKeys;

  "tankstelle-forgejo-actions-runner-token.age".publicKeys = tankstelleKeys ++ adminKeys;
  "trinkgenossin-forgejo-actions-runner-token.age".publicKeys = trinkgenossinKeys ++ adminKeys;
  "trinkgenossin-forgejo-actions-runner-token-miom.age".publicKeys = trinkgenossinKeys ++ adminKeys;
  "trinkgenossin-forgejo-actions-runner-token-momo.age".publicKeys = trinkgenossinKeys ++ adminKeys;
  "forgejo-database-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "forgejo-mailer-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "forgejo-ssh-private-key.age".publicKeys = nachtigallKeys ++ adminKeys;

  "matrix-mautrix-telegram-env-file.age".publicKeys = nachtigallKeys ++ adminKeys;
  "matrix-synapse-signing-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "matrix-synapse-secret-config.yaml.age".publicKeys = nachtigallKeys ++ adminKeys;
  "matrix-authentication-service-secret-config.yml.age".publicKeys = nachtigallKeys ++ adminKeys;
  "matrix-appservice-irc-mediaproxy-signing-key.jwk.age".publicKeys = nachtigallKeys ++ adminKeys;

  "staging-matrix-synapse-secret-config.yaml.age".publicKeys = undergroundKeys ++ adminKeys;
  "staging-matrix-authentication-service-secret-config.yml.age".publicKeys =
    undergroundKeys ++ adminKeys;
  "staging-matrix-appservice-irc-mediaproxy-signing-key.jwk.age".publicKeys =
    undergroundKeys ++ adminKeys;

  "nextcloud-secrets.age".publicKeys = nachtigallKeys ++ adminKeys;
  "nextcloud-admin-pass.age".publicKeys = nachtigallKeys ++ adminKeys;
  "nextcloud-serverinfo-token.age".publicKeys = nachtigallKeys ++ adminKeys;

  "searx-environment.age".publicKeys = nachtigallKeys ++ adminKeys;

  "restic-repo-garage-metronom.age".publicKeys = metronomKeys ++ adminKeys;
  "restic-repo-garage-metronom-env.age".publicKeys = metronomKeys ++ adminKeys;
  "restic-repo-droppie.age".publicKeys = nachtigallKeys ++ adminKeys;
  "restic-repo-storagebox-nachtigall.age".publicKeys = nachtigallKeys ++ adminKeys;
  "restic-repo-storagebox-metronom.age".publicKeys = metronomKeys ++ adminKeys;
  "restic-repo-garage-nachtigall.age".publicKeys = nachtigallKeys ++ adminKeys;
  "restic-repo-garage-nachtigall-env.age".publicKeys = nachtigallKeys ++ adminKeys;

  "mediawiki-database-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mediawiki-admin-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mediawiki-oidc-client-secret.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mediawiki-secret-key.age".publicKeys = nachtigallKeys ++ adminKeys;

  "coturn-static-auth-secret.age".publicKeys = nachtigallKeys ++ adminKeys;

  "mollysocket-env.age".publicKeys = nachtigallKeys ++ adminKeys;

  "grafana-admin-password.age".publicKeys = trinkgenossinKeys ++ adminKeys;
  "grafana-keycloak-client-secret.age".publicKeys = trinkgenossinKeys ++ adminKeys;
  "grafana-smtp-password.age".publicKeys = trinkgenossinKeys ++ adminKeys;

  "alertmanager-envfile.age".publicKeys = trinkgenossinKeys ++ adminKeys;

  "codeberg-pages-envfile.age".publicKeys = trinkgenossinKeys ++ adminKeys;

  "obs-portal-env.age".publicKeys = nachtigallKeys ++ adminKeys;
  "obs-portal-database-env.age".publicKeys = nachtigallKeys ++ adminKeys;

  "tt-rss-feed-crypt-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "tt-rss-keycloak-client-secret.age".publicKeys = nachtigallKeys ++ adminKeys;
  "tt-rss-smtp-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "tt-rss-database-password.age".publicKeys = nachtigallKeys ++ adminKeys;

  # mail
  "mail/hensoko.age".publicKeys = metronomKeys ++ adminKeys;
  "mail/teutat3s.age".publicKeys = metronomKeys ++ adminKeys;
  "mail/admins.age".publicKeys = metronomKeys ++ adminKeys;
  "mail/bot.age".publicKeys = metronomKeys ++ adminKeys;
  "mail/crew.age".publicKeys = metronomKeys ++ adminKeys;
  "mail/erpnext.age".publicKeys = metronomKeys ++ adminKeys;
  "mail/hakkonaut.age".publicKeys = metronomKeys ++ adminKeys;

  # garage
  "garage-rpc-secret.age".publicKeys = garageKeys ++ adminKeys;
  "garage-admin-token.age".publicKeys = garageKeys ++ adminKeys;

  "acme-namecheap-env.age".publicKeys = garageKeys ++ adminKeys;

}
