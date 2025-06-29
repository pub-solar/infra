# Process for handling a deletion request

## Automated script

Required:

- [SSH access to host `nachtigall`](./administrative-access.md#ssh-access)

SSH into nachtigall, and run the following script. Replace `<username>` with the `Username` found in keycloak.

```
delete-pubsolar-id $(sudo cat /run/agenix/keycloak-admin-cli-client-secret) $(sudo cat /run/agenix/matrix-admin-access-token) <username>
```

Make sure to close all Matrix user sessions:

```
# get full path to mas-cli command with current --config flags from
# sudo systemctl cat matrix-authentication-service
sudo -u matrix-authentication-service <nix-store-path>/mas-cli --config <nix-store-config> --config /run/agenix/matrix-authentication-service-secret-config.yml manage kill-sessions <username>
```

### Keycloak

Required:

- auth.pub.solar `admin-cli` service user credentials
- [SSH access to host `nachtigall`](./administrative-access.md#ssh-access)

Run each of the following after SSH'ing to `nachtigall`:

```
sudo --user keycloak kcadm.sh config credentials --config /tmp/kcadm.config --server http://localhost:8080 --realm pub.solar --client admin-cli

# Take note of user id in response from following command
sudo --user keycloak kcadm.sh get --config /tmp/kcadm.config users --realm pub.solar --query email=<email-address>

# To avoid impersonification, we deactivate the account by resetting the password and email address
# Use user id from previous command, for example
sudo --user keycloak kcadm.sh update --config /tmp/kcadm.config users/2ec6f173-3c10-4b82-9808-e2f2d393ff11/reset-password --realm pub.solar --set type=password --set value=<random-password> --no-merge
sudo --user keycloak kcadm.sh update --config /tmp/kcadm.config users/2ec6f173-3c10-4b82-9808-e2f2d393ff11 --realm pub.solar --set email=<username>@deactivated.pub.solar
```

Docs: https://www.keycloak.org/docs/latest/server_admin/index.html#updating-a-user

### Nextcloud

```
sudo nextcloud-occ user:delete <username>
```

Docs: https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/occ_command.html#user-commands-label

### Mastodon

```
mkdir /tmp/tootctl
sudo chown mastodon /tmp/tootctl
cd /tmp/tootctl

sudo -u mastodon mastodon-tootctl accounts delete --email <mail-address>

rm -r /tmp/tootctl
```

Docs: https://docs.joinmastodon.org/admin/tootctl/#accounts-delete

### Forgejo

Make sure you have access to the gitea/forgejo command:

```
nix shell nixpkgs#forgejo
```

Then, delete the user:

```
sudo -u gitea gitea admin user delete --config /var/lib/forgejo/custom/conf/app.ini --purge --email <mail-address>
```

Docs: https://forgejo.org/docs/latest/admin/command-line/#delete

### Matrix

Close all user sessions:

```
# get full path to mas-cli command with current --config flags from
# sudo systemctl cat matrix-authentication-service
sudo -u matrix-authentication-service <nix-store-path>/mas-cli --config <nix-store-config> --config /run/agenix/matrix-authentication-service-secret-config.yml manage kill-sessions <username>
```

Deactivate the user and erase data:

```
curl --header "Authorization: Bearer <admin-access-token>" --request POST http://127.0.200.10:8008/_synapse/admin/v1/deactivate/@<username>:pub.solar --data '{"erase": true}'
```

Docs: https://element-hq.github.io/synapse/latest/admin_api/user_admin_api.html#deactivate-account

The authentication token should be in the keepass. If it is expired, you can get a new one by running the following:

```
# get full path to mas-cli command with current --config flags from
# sudo systemctl cat matrix-authentication-service
sudo -u matrix-authentication-service <nix-store-path>/mas-cli --config <nix-store-config> --config /run/agenix/matrix-authentication-service-secret-config.yml manage issue-compatibility-token --yes-i-want-to-grant-synapse-admin-privileges crew
```

### OpenBikeSensor

Not implemented, see: https://github.com/openbikesensor/portal/issues/95

## Notifying the user

Make sure to send an e-mail to the specified address notifying the user of the accounts deletion.

You can use this template:

```
Hello,

Your pub.solar ID has been deactivated. Associated data in pub.solar services has been deleted.

Please note that the username is now blocked to prevent impersonation attempts.

Best,

@<name> for the pub.solar crew
```
