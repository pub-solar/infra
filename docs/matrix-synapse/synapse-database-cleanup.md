# Synapse database cleanup

Using these steps, the `synapse` database has been successfully shrinked from ~325GB to ~128GB in the past.

Based on:
- https://blog.bgme.me/posts/2023/how-to-clean-up-the-synapse-database/
- https://github.com/matrix-org/synapse/issues/12821#issuecomment-1295773504

Check for rooms with a high number of state events. To reduce synapse database size and slighly improve performance,
we manually kick users and clean up old room history. User can re-join the rooms afterwards and will re-sync recent history from other homeservers.


SSH to nachtigall.

```
mkdir -p synapse-cleanup && cd $_
```

First look for old rooms without joined local members.

```
curl --silent --header "Authorization: Bearer $(sudo cat /run/agenix/matrix-admin-access-token)" http://127.0.200.10:8008/_synapse/admin/v1/rooms?limit=300000 > roomlist-$(date +%F).json
```

```
jq -r '.rooms[] | select(.joined_local_members == 0) | .room_id' < roomlist-$(date +%F).json > rooms_to_purge.txt
```

```
for room_id in $(cat rooms_to_purge.txt);
  do curl --silent \
    --header "Authorization: Bearer $(sudo cat /run/agenix/matrix-admin-access-token)" \
      "http://127.0.200.10:8008/_synapse/admin/v1/rooms/${room_id}" \
    | jq \
    | grep creator;
done
```

```
for room_id in $(cat rooms_to_purge.txt);
  do curl --silent \
    --header "Authorization: Bearer $(sudo cat /run/agenix/matrix-admin-access-token)" \
      "http://127.0.200.10:8008/_synapse/admin/v1/rooms/${room_id}/members" \
    | jq \
    | grep pub.solar \
    | grep -v irc;
done
```

Script to asynchronously delete rooms by `room_id`, kicking out `pub.solar` users.

`purge-rooms.sh`
```shell
#!/usr/bin/env bash

set -euo pipefail

TOKEN="$1"
ROOMLIST="$2"
while IFS='' read ROOMID; do
  echo "Cleaning up Room: $ROOMID"
  curl "http://127.0.200.10:8008/_synapse/admin/v2/rooms/${ROOMID}" \
    -X DELETE -H 'Accept: application/json' \
    -H 'Referer: http://localhost:8080/' \
    -H "authorization: Bearer ${TOKEN}" \
    --data '{ "purge": true, "message": "Sorry - kicking you out to clean up the database" }'
  echo ""
done < $ROOMLIST
```

```
./purge-rooms.sh $(sudo cat /run/agenix/matrix-admin-access-token) ./rooms_to_purge.txt
```

```
sudo -u postgres psql -d matrix
matrix=#
```

Find large rooms, sorted by most
```
SELECT r.name, s.room_id, s.current_state_events
    FROM room_stats_current s
    LEFT JOIN room_stats_state r USING (room_id)
    ORDER BY current_state_events DESC
    LIMIT 20;
```

```
SELECT rss.name, s.room_id, COUNT(s.room_id)
    FROM state_groups_state s
    LEFT JOIN room_stats_state rss USING (room_id)
    GROUP BY s.room_id, rss.name
    ORDER BY COUNT(s.room_id) DESC
    LIMIT 20;
```

If desired, investigate rooms with [synapse-admin](). Good candidates for history purging are archived rooms.

Save `room_id`s to a file:

```
vim old-rooms-to-purge.txt
```

Repeat the purge-rooms.sh script with this list:

```
./purge-rooms.sh $(sudo cat /run/agenix/matrix-admin-access-token) ./old-rooms_to_purge.txt
```

Room deletion status can be checked with:

`delete-status.sh`
```
#!/usr/bin/env bash

set -euo pipefail

TOKEN="$1"
ROOMLIST="$2"
while IFS='' read ROOMID; do
	statuses=$(curl -sSL "http://127.0.200.10:8008/_synapse/admin/v2/rooms/${ROOMID}/delete_status" \
		-H "authorization: Bearer ${TOKEN}")
	echo "$statuses" | jq -c '. * { "room_id": "'"$ROOMID"'" }'
	echo ""
done < $ROOMLIST
```

```
./delete-status.sh $(sudo cat /run/agenix/matrix-admin-access-token) ./rooms_to_purge.txt
```

All deletions should show `"status":"complete"`

Stop `synapse` before continuing:

```
sudo systemctl stop matrix-synapse.service matrix-synapse-worker-federation-receiver-1.service matrix-synapse-worker-federation-receiver-2.service matrix-synapse-worker-federation-receiver-3.service matrix-synapse-worker-federation-receiver-4.service matrix-synapse-worker-federation-sender-1.service matrix-synapse-worker-client-1.service matrix-appservice-irc.service matrix-authentication-service.service
```

```
sudo -u postgres synapse_auto_compressor -p 'host=/run/postgresql user=postgres dbname=matrix' -c 10000 -n 100000000
```

```
REINDEX (VERBOSE) DATABASE matrix;
VACUUM FULL VERBOSE;
```

```
sudo systemctl start matrix-synapse.service matrix-synapse-worker-federation-receiver-1.service matrix-synapse-worker-federation-receiver-2.service matrix-synapse-worker-federation-receiver-3.service matrix-synapse-worker-federation-receiver-4.service matrix-synapse-worker-federation-sender-1.service matrix-synapse-worker-client-1.service matrix-appservice-irc.service matrix-authentication-service.service
```

### Troubleshooting `synapse_auto_compressor`

Issue: https://github.com/matrix-org/rust-synapse-compress-state/issues/78

Error message similar to:

```
[2025-11-01T02:30:31Z ERROR panic] thread 'main' panicked at 'Missing 88328': src/lib.rs:666
```

Clean up the `state_compressor_state` table in the database, then re-run the command again.

```
sudo -u postgres psql -d matrix
matrix=#
```

```
DELETE
FROM state_compressor_state AS scs
WHERE NOT EXISTS
    (SELECT *
     FROM rooms AS r
     WHERE r.room_id = scs.room_id);
```

```
DELETE
FROM state_compressor_state AS scs
WHERE scs.room_id in
    (SELECT DISTINCT room_id
     FROM state_compressor_state AS scs2
     WHERE scs2.current_head IS NOT NULL
       AND NOT EXISTS
         (SELECT *
          FROM state_groups AS sg
          WHERE sg.id = scs2.current_head));
```

```
DELETE
FROM state_compressor_progress AS scp
WHERE NOT EXISTS
    (SELECT *
     FROM state_compressor_state AS scs
     WHERE scs.room_id = scp.room_id);
```
