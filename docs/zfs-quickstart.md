# ZFS Quick Start

View current status of the ZFS pool (zpool):

```
sudo zpool status
```

View available disk space of the pool, replace `<pool-name>` with the pool name from the output above:

```
sudo zfs list <pool-name>
```

List all snapshots:

```
sudo zfs list -t snapshot
```
