# Delete accounts without verified email address

### Keycloak

Required:

- auth.pub.solar admin-cli service user credentials
- SSH access to host nachtigall

```
ssh barkeeper@nachtigall.wg.pub.solar
```

Credentials for the following command are in keepass.

Create keycloak config/credentials file at `/tmp/kcadm.config`:

```
sudo --user keycloak kcadm.sh config credentials \
  --config /tmp/kcadm.config \
  --server https://auth.pub.solar \
  --realm pub.solar \
  --client admin-cli
```

Get list of accounts without a verified email address:

```
sudo --user keycloak kcadm.sh get \
  --config /tmp/kcadm.config \
  users \
  --realm pub.solar \
  --query emailVerified=false \
  > /tmp/keycloak-unverified-accounts
```

Review list of accounts, especially check `createdTimestamp` if any accounts
were created in the past 2 days. If so, delete those from the
`/tmp/keycloak-unverified-accounts` file.

```
createdTimestamps=( $( nix run nixpkgs#jq -- -r '.[].createdTimestamp' < /tmp/keycloak-unverified-accounts ) )

# timestamps are in nanoseconds since epoch, so we need to strip the last three digits
for timestamp in ${createdTimestamps[@]}; do date --date="@${timestamp::-3}"; done

vim /tmp/keycloak-unverified-accounts
```

Check how many accounts are going to be deleted:

```
jq -r '.[].id' < /tmp/keycloak-unverified-accounts | wc -l
```

```
jq -r '.[].id' < /tmp/keycloak-unverified-accounts > /tmp/keycloak-unverified-account-ids
```

Final check before deletion (dry-run):

```
for id in $(cat /tmp/keycloak-unverified-account-ids)
  do
    echo sudo --user keycloak kcadm.sh delete \
      --config /tmp/kcadm.config \
      users/$id \
      --realm pub.solar
  done
```

THIS WILL DELETE ACCOUNTS:

```
for id in $(cat /tmp/keycloak-unverified-account-ids)
  do
    sudo --user keycloak kcadm.sh delete \
      --config /tmp/kcadm.config \
      users/$id \
      --realm pub.solar
  done
```
