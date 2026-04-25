# Keycloak custom claims and roles

## Grafana
- [Realm role](https://auth.pub.solar/admin/master/console/#/pub.solar/roles/3ade59b2-e82a-45ee-8834-2fcf8c62703e/details) `admin`

Grants admin permissions in https://grafana.pub.solar

## Immich

Custom [user profile attributes](https://auth.pub.solar/admin/master/console/#/pub.solar/realm-settings/user-profile):
- `immich_role`

Default: `user`
Value `admin` grants administrator privileges in https://photos.pub.solar.

[Localized](https://auth.pub.solar/admin/master/console/#/pub.solar/realm-settings/localization) key `profile.attributes.immich_role` in "Realm overrides"
