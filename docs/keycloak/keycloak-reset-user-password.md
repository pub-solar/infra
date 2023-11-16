# Process for resetting keycloak user passwords

### Keycloak
Required:
- auth.pub.solar ops user credentials
- SSH access to host flora-6
```
ssh barkeeper@flora-6.pub.solar

mkdir /tmp/keycloak-credential-reset

sudo --user keycloak kcadm.sh config credentials --config /tmp/kcadm.config --server http://localhost:8080 --realm pub.solar --user ops

sudo --user keycloak kcadm.sh get --config /tmp/kcadm.config users --realm pub.solar | jq --raw-output '.[] | .id' > /tmp/keycloak-credential-reset/all-uuids

for UUID in $(cat /tmp/keycloak-credential-reset/all-uuids); do
  sudo --user keycloak kcadm.sh get --config /tmp/kcadm.config users/$UUID/credentials --realm pub.solar > /tmp/keycloak-credential-reset/$UUID
done

mkdir /tmp/keycloak-credential-reset/accounts-with-creds

find /tmp/keycloak-credential-reset -type f -size +3c -exec mv '{}' /tmp/keycloak-credential-reset/accounts-with-creds/ \;

rm -r /tmp/keycloak-credential-reset/accounts-with-creds/

find /tmp/keycloak-credential-reset/ -type f -exec basename '{}' \; > /tmp/keycloak-credential-reset/accounts-without-credentials

vim /tmp/keycloak-credential-reset/accounts-without-credentials

for UUID in $(cat /tmp/keycloak-credential-reset/accounts-without-credentials); do
  sudo --user keycloak kcadm.sh update --config /tmp/kcadm.config users/$UUID/reset-password --target-realm pub.solar --set type=password --set value=$(< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-32};echo;) --set temporary=true --no-merge
done
```
