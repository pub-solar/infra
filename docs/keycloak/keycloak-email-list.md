# Process for getting a list of email addresses of all keycloak users

### Keycloak
Required:
- auth.pub.solar ops user credentials
- SSH access to host flora-6
```
ssh barkeeper@flora-6.pub.solar

sudo --user keycloak kcadm.sh get users \
  -r pub.solar \
  --offset 0 \
  --limit 1000 \
  --no-config \
  --server http://localhost:8080 \
  --realm master \
  --user admin \
  --password <admin password> \
  > keycloak-user-list.json

jq -r '.[].email' < keycloak-user-list.json
```
