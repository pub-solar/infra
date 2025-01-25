# Automated account deletion

Per GDPR legislation, accounts should be automatically deleted after a period of inactivity. We discern between two different types of accounts:

1. Without verified email: should be deleted after 30 days without being activated
2. With verified email: should be deleted after 2 years of inactivity

Some services hold on to a session for a very long time. We'll have to query their APIs to see if the account is still in use:

- Matrix via the admin api: https://matrix-org.github.io/synapse/v1.48/admin_api/user_admin_api.html#query-current-sessions-for-a-user
- Mastodon via the admin api: https://docs.joinmastodon.org/methods/admin/accounts/#200-ok
- Nextcloud only gives the last login, not the last active time like a sync via `nextcloud-occ user:lastseen`
- Keycloak
- We can ignore Forgejo, since the sessions there are valid for a maximum of one year, regardless of how they got created
