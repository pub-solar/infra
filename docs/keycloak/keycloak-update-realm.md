# Process for updating a keycloak realm via CLI

### Keycloak
Required:
- auth.pub.solar ops user credentials
- SSH access to host nachtigall
```
ssh barkeeper@nachtigall.pub.solar

sudo -u keycloak kcadm.sh config credentials --config /tmp/kcadm.config --server http://localhost:8080 --realm master --user admin

sudo -u keycloak kcadm.sh get --config /tmp/kcadm.config realms/pub.solar

sudo -u keycloak kcadm.sh update --config /tmp/kcadm.config realms/pub.solar -s browserFlow='Webauthn Browser'

sudo -u keycloak kcadm.sh get --config /tmp/kcadm.config realms/pub.solar
```

Source: https://keycloak.ch/keycloak-tutorials/tutorial-webauthn/