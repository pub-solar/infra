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

Removing rooms, requires a list of room IDs:

Example script `purge-rooms.sh`

Usage:

```
./purge-rooms.sh <token> <file-containing-room-ids>
```

```
#!/usr/bin/env bash

set -euo pipefail

TOKEN=$1
ROOMLIST=$2
while IFS='' read ROOMID; do
	echo "Cleaning up Room: $ROOMID"
	curl "http://127.0.200.10:8008/_synapse/admin/v2/rooms/${ROOMID}" \
		-X DELETE -H 'Accept: application/json' \
		-H 'Referer: http://127.0.200.10:8080/' \
		-H "Authorization: Bearer ${TOKEN}" \
		--data '{ "purge": true, "message": "Sorry - kicking you out to clean up the database" }'
	echo ""
done < "$ROOMLIST"
```

Remove all media uploaded by user:

```
export TOKEN=$(sudo cat /run/agenix/matrix-admin-access-token)

curl "http://127.0.200.10:8008/_synapse/admin/v1/users/@<username>:pub.solar/media" \
  -X DELETE -H 'Accept: application/json' \
  -H 'Referer: http://127.0.200.10:8080/' \
  -H "Authorization: Bearer ${TOKEN}"
```
