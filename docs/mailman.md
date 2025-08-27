# Mailman on NixOS docs

- add reverse DNS record for IP

Manual setup done for mailman, adapted from https://wiki.nixos.org/wiki/Mailman:

```
# Add DNS records in infra repo using terraform:

# https://git.pub.solar/pub-solar/infra-vintage/commit/db234cdb5b55758a3d74387ada0760e06e166b9d

# Generate initial postfix_domains.db and postfix_lmtp.db databases for Postfix

sudo -u mailman mailman aliases

# Create a django superuser account

sudo -u mailman-web mailman-web createsuperuser

# Followed outlined steps in web UI
```
