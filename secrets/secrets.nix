let
  admins = import ../logins/admins.nix;

  nachtigall-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7G0ufi+MNvaAZLDgpieHrABPGN7e/kD5kMFwSk4ABj root@nachtigall";
  flora-6-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGP1InpTBN4AlF/4V8HHumAMLJzeO8DpzjUv9Co/+J09 root@flora-6";
  metronom-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICLX6UvvrKALKL0xsNnytLPHryzZF5evUnxAgGokf14i root@metronom";
  tankstelle-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdF6cJKPDiloWiDja1ZtqkXDdXOCHPs10HD+JMzgeU4 root@tankstelle";

  adminKeys = builtins.foldl' (
    keys: login: keys ++ (builtins.attrValues login.secretEncryptionKeys)
  ) [ ] (builtins.attrValues admins);

  nachtigallKeys = [ nachtigall-host ];

  tankstelleKeys = [ tankstelle-host ];

  flora6Keys = [ flora-6-host ];

  metronomKeys = [ metronom-host ];
in
{
  # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBB5XaH02a6+TchnyQED2VwaltPgeFCbildbE2h6nF5e root@nachtigall
  "nachtigall-root-ssh-key.age".publicKeys = nachtigallKeys ++ adminKeys;

  "nachtigall-wg-private-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "tankstelle-wg-private-key.age".publicKeys = tankstelleKeys ++ adminKeys;
  "flora6-wg-private-key.age".publicKeys = flora6Keys ++ adminKeys;
  "metronom-wg-private-key.age".publicKeys = metronomKeys ++ adminKeys;

  "mastodon-secret-key-base.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-otp-secret.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-vapid-private-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-vapid-public-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-smtp-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-extra-env-secrets.age".publicKeys = nachtigallKeys ++ adminKeys;

  "keycloak-database-password.age".publicKeys = nachtigallKeys ++ adminKeys;

  "forgejo-actions-runner-token.age".publicKeys = flora6Keys ++ adminKeys;
  "tankstelle-forgejo-actions-runner-token.age".publicKeys = tankstelleKeys ++ adminKeys;
  "forgejo-database-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "forgejo-mailer-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "forgejo-ssh-private-key.age".publicKeys = nachtigallKeys ++ adminKeys;

  "matrix-mautrix-telegram-env-file.age".publicKeys = nachtigallKeys ++ adminKeys;
  "matrix-synapse-signing-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "matrix-synapse-secret-config.yaml.age".publicKeys = nachtigallKeys ++ adminKeys;
  "matrix-synapse-sliding-sync-secret.age".publicKeys = nachtigallKeys ++ adminKeys;

  "nextcloud-secrets.age".publicKeys = nachtigallKeys ++ adminKeys;
  "nextcloud-admin-pass.age".publicKeys = nachtigallKeys ++ adminKeys;

  "searx-environment.age".publicKeys = nachtigallKeys ++ adminKeys;

  "restic-repo-droppie.age".publicKeys = nachtigallKeys ++ adminKeys;
  "restic-repo-storagebox.age".publicKeys = nachtigallKeys ++ adminKeys;

  "drone-db-secrets.age".publicKeys = flora6Keys ++ adminKeys;
  "drone-secrets.age".publicKeys = flora6Keys ++ adminKeys;

  "mediawiki-database-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mediawiki-admin-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mediawiki-oidc-client-secret.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mediawiki-secret-key.age".publicKeys = nachtigallKeys ++ adminKeys;

  "coturn-static-auth-secret.age".publicKeys = nachtigallKeys ++ adminKeys;

  "grafana-admin-password.age".publicKeys = flora6Keys ++ adminKeys;
  "grafana-keycloak-client-secret.age".publicKeys = flora6Keys ++ adminKeys;
  "grafana-smtp-password.age".publicKeys = flora6Keys ++ adminKeys;

  "alertmanager-envfile.age".publicKeys = flora6Keys ++ adminKeys;

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
}
