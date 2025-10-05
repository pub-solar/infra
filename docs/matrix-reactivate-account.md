# Matrix reactivate account

If a user accidentially deletes (deactivates) their matrix account, these are the steps to reactivate the account.

SSH to `nachtigall`.

`matrix-authentication-service`

```
sudo -u postgres psql -d matrix-authentication-service

# example for account @<username>:pub.solar
matrix-authentication-service=# UPDATE users SET deactivated_at = NULL where username = '<username>';
UPDATE 1
matrix-authentication-service=# \q
```

`synapse`

```
# example for account @<username>:pub.solar
curl --header "Authorization: Bearer $(sudo cat /run/agenix/matrix-admin-access-token)" --request GET 'http://127.0.200.10:8008/_synapse/admin/v2/users/@<username>:pub.solar' | jq
curl --header "Authorization: Bearer $(sudo cat /run/agenix/matrix-admin-access-token)" --request PUT 'http://127.0.200.10:8008/_synapse/admin/v2/users/@<username>:pub.solar' --data '{"deactivated": false}' | jq
curl --header "Authorization: Bearer $(sudo cat /run/agenix/matrix-admin-access-token)" --request GET 'http://127.0.200.10:8008/_synapse/admin/v2/users/@<username>:pub.solar' | jq
```
