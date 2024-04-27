# OpenBikeSensor Portal

## Docker Containers
* portal
* worker
* db


## Run database migrations

```
docker exec -ti obs-portal tools/upgrade.py
```

## Dump database

```
docker exec -ti --user postgres obs-portal-db pg_dump obs
```

## Restore database

```
cat dump.sql | docker exec -ti --user postgres obs-portal-db psql obs
```
