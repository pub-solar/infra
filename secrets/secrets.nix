let
  admins = import ../logins/admins.nix;

  nachtigall-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7G0ufi+MNvaAZLDgpieHrABPGN7e/kD5kMFwSk4ABj root@nachtigall";
  flora-6-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGP1InpTBN4AlF/4V8HHumAMLJzeO8DpzjUv9Co/+J09 root@flora-6";

  adminKeys = builtins.foldl' (
    keys: login: keys ++ (builtins.attrValues login.secretEncryptionKeys)
  ) [ ] (builtins.attrValues admins);

  nachtigallKeys = [ nachtigall-host ];

  flora6Keys = [ flora-6-host ];
in
{
  # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBB5XaH02a6+TchnyQED2VwaltPgeFCbildbE2h6nF5e root@nachtigall
  "nachtigall-root-ssh-key.age".publicKeys = nachtigallKeys ++ adminKeys;

  "nachtigall-wg-private-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "flora6-wg-private-key.age".publicKeys = flora6Keys ++ adminKeys;

  "mastodon-secret-key-base.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-otp-secret.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-vapid-private-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-vapid-public-key.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-smtp-password.age".publicKeys = nachtigallKeys ++ adminKeys;
  "mastodon-extra-env-secrets.age".publicKeys = nachtigallKeys ++ adminKeys;

  "keycloak-database-password.age".publicKeys = nachtigallKeys ++ adminKeys;

  "forgejo-actions-runner-token.age".publicKeys = flora6Keys ++ adminKeys;
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
  "nachtigall-metrics-nginx-basic-auth.age".publicKeys = nachtigallKeys ++ adminKeys;
  "nachtigall-metrics-prometheus-basic-auth-password.age".publicKeys =
    flora6Keys ++ nachtigallKeys ++ adminKeys;

  "obs-portal-env.age".publicKeys = nachtigallKeys ++ adminKeys;
  "obs-portal-database-env.age".publicKeys = nachtigallKeys ++ adminKeys;
}
