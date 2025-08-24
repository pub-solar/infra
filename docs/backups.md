# Backups

We use [Restic](https://restic.readthedocs.io/en/stable/) to create backups and push them to two repositories.
Check `./modules/backups.nix` and `./hosts/nachtigall/backups.nix` for working examples.

### Hetzner Storagebox

- Uses SFTP for transfer of backups

Adding a new host SSH public key to the storagebox:

First, [SSH to nachtigall](./administrative-access.md#ssh-access), then become root and add the new SSH public key

```
sudo -i
echo '<ssh-public-key>' | ssh -p23 u377325@u377325.your-storagebox.de install-ssh-key
```

[Link to Hetzner storagebox docs](https://docs.hetzner.com/robot/storage-box/backup-space-ssh-keys).

### Garage S3 buckets

- Uses S3 for transfer of backups
- One bucket per host, e.g. `nachtigall-backups`, `metronom-backups`

To start transfering backups from a new hosts, this is how to create a new bucket:

First, [SSH to trinkgenossin](./administrative-access.md#ssh-access), then use the `garage` CLI to create a new key and bucket:

```
export GARAGE_RPC_SECRET=<secret-in-keepass>

garage bucket create <hostname>-backups
garage key create <hostname>-backups-key
garage bucket allow <hostname>-backups --read --write --key <hostname>-backups-key
```

### Restic common tasks

View `nachtigall` snapshots, grouped by `path`:

First, [SSH to nachtigall](./administrative-access.md#ssh-access), then:

Storage box: view all snapshots

```
sudo restic-matrix-synapse-storagebox snapshots --group-by path
```

Garage: view all snapshots

```
sudo restic-matrix-synapse-garage snapshots --group-by path
```

#### Disk full / No space left on device

This mostly happens when the disk is too full and [restic fails to prune](https://restic.readthedocs.io/en/stable/060_forget.html#recovering-from-no-free-space-errors)
snapshots, or snapshot pruning failed for some other reason.

First, we need to free up some space by deleting old restic snapshots. For
storagebox, replace with `restic-matrix-synapse-storagebox`:

```
sudo restic-matrix-synapse-garage forget <snapshot-ID> <another-snapshot-ID>
```

```
sudo restic-matrix-synapse-garage prune --max-repack-size 0
```

After this, normal `restic prune` and repack should work fine again, which will
run automatically with `restic-backups-obs-portal-{garage,storagebox}.service`.
