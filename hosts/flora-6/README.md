# Deploy infra branch to flora-6

Use this command after updating flake inputs to update services on `flora-6`.

```
deploy --skip-checks --confirm-timeout 300 --targets '.#flora-6'

An alternative, if deployment always fails and rolls back.

```

deploy --skip-checks --magic-rollback false --auto-rollback false --targets '.#flora-6'

```

# SSH access to flora-6
Ensure your SSH public key is in place [here](./users/barkeeper/default.nix) and
was deployed by someone with access.

```

ssh barkeeper@flora-6.pub.solar

```

# Mailman on NixOS docs

- add reverse DNS record for IP

Manual setup done for mailman, adapted from https://nixos.wiki/wiki/Mailman:

```

# Add DNS records in infra repo using terraform:

# https://git.pub.solar/pub-solar/infra/commit/db234cdb5b55758a3d74387ada0760e06e166b9d

# Generate initial postfix_domains.db and postfix_lmtp.db databases for Postfix

sudo -u mailman mailman aliases

# Create a django superuser account

sudo -u mailman-web mailman-web createsuperuser

# Followed outlined steps in web UI

```

```
