# OpenBikeSensor Portal

## Docker Containers

- portal
- worker
- db

## Run database migrations

After an upgrade it is sometimes necessary to run database migrations or regenerate tiles.

```
docker exec -ti obs-portal tools/upgrade.py
```

## Dump database

Save database dump to `dump.sql` in the current working directory.

```
docker exec -ti --user postgres obs-portal-db pg_dump obs > dump.sql
```

## Restore database

Load database dump from `dump.sql` file.
`obs` database needs to exist before importing the dump.

```
cat dump.sql | docker exec -ti --user postgres obs-portal-db psql obs
```
