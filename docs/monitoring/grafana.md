# Grafana

**URL:** https://grafana.pub.solar

Click "Login with pub.solar ID"

Default access level: `Viewer`, but there should be no dashboards or Explore menu option visible.

For access to dashboards, add the `admin` realm role to the respective pub.solar ID in keycloak.

1. Select user in keycloak admin web UI
2. Click `Role mapping`
3. Click `Assign role`
4. Click `Filter by realm roles`
5. Select `admin` role, with Description: `Grafana admin role`
6. Click `Apply`
