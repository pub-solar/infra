# Process for handling a deletion request

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
nextcloud-occ user:delete <username>
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

```
sudo -u gitea gitea admin user delete --config /var/lib/forgejo/custom/conf/app.ini --purge --email <mail-address>
```

Docs: https://forgejo.org/docs/latest/admin/command-line/#delete

### Matrix

```
curl --header "Authorization: Bearer <admin-access-token>" --request POST http://127.0.0.1:8008/_synapse/admin/v1/deactivate/@<username>:pub.solar --data '{"erase": true}'
```

Docs: https://matrix-org.github.io/synapse/latest/admin_api/user_admin_api.html#deactivate-account

### OpenBikeSensor

Not implemented, see: https://github.com/openbikesensor/portal/issues/95
