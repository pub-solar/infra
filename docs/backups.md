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
