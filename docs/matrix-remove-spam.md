# Remove spam from Matrix synapse homeserver

Required:

- [SSH access to host `nachtigall`](./administrative-access.md#ssh-access)

Connect to `matrix` PostgreSQL DB:

```
sudo -u postgres psql -d matrix
```

List all rooms joined by user:

```
SELECT e.room_id, r.name
FROM current_state_events e
JOIN room_stats_state r USING (room_id)
WHERE e.state_key = '@<username>:pub.solar'
AND e.type = 'm.room.member'
AND e.membership = 'join';
```

Remove all media uploaded by user:

```
export TOKEN=$(sudo cat /run/agenix/matrix-admin-access-token)

curl "http://localhost:8008/_synapse/admin/v1/users/@<username>:pub.solar/media" \
  -X DELETE -H 'Accept: application/json' \
  -H 'Referer: http://localhost:8080/' \
  -H "authorization: Bearer ${TOKEN}"
```
