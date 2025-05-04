# Notes for setting up draupnir moderation bot

From: https://the-draupnir-project.github.io/draupnir-documentation/bot/setup

### Overview

There are a number of steps to complete to get Draupnir running:

1. [Create an account](https://the-draupnir-project.github.io/draupnir-documentation/bot/setup_draupnir_account) for Draupnir to use.
   1. Optionally [disabling rate limits](https://matrix-org.github.io/synapse/latest/admin_api/user_admin_api.html#set-ratelimit) for this account.
   1. Make user an [admin account in synapse](https://element-hq.github.io/synapse/latest/usage/administration/admin_api/index.html)
1. Review our notes on [encryption](https://the-draupnir-project.github.io/draupnir-documentation/bot/encryption).
1. [Create a management room](https://the-draupnir-project.github.io/draupnir-documentation/bot/setup_management_room) for Draupnir to use.
1. Install Draupnir on your system (we use NixOS for this)

### After creating the draupnir account

Disable rate limit via synapse admin API:

```
curl --header "Authorization: Bearer $TOKEN" 'http://127.0.0.1:8008/_synapse/admin/v1/users/@draupnir:pub.solar/override_ratelimit' -X POST -d '{"messages_per_second": 0,  "burst_count": 0}'
```

Make draupnir admin

```
sudo -u postgres psql -d matrix
matrix=# UPDATE users SET admin = 1 WHERE name = '@draupnir:pub.solar';
```

With matrix-authentication-service (MAS), getting an admin token for the
draupnir user is different. Run the following commands on the host running
matrix-authentication-service.

Get the required nix store paths for `mas-cli`, copy it from the output of the
following command:

```
sudo systemctl cat matrix-authentication-service
```

Get a admin token for the `draupnir` matrix account:

```
sudo -u matrix-authentication-service <nix-store-path>/bin/mas-cli --config <nix-store-path>/-config.yaml --config /run/agenix/staging-matrix-authentication-service-secret-config.yml manage issue-compatibility-token --yes-i-want-to-grant-synapse-admin-privileges draupnir
```

This ensures the `draupnir` user has devices configured, which is required by synapse:

```
sudo -u matrix-authentication-service <nix-store-path>/bin/mas-cli --config <nix-store-path>/-config.yaml --config /run/agenix/staging-matrix-authentication-service-secret-config.yml manage provision-all-users
```
