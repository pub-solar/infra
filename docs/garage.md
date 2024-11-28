# Garage

### How-To create a new bucket + keys

Requirements:

- `garage` RPC credentials, in the shared keepass, search for 'garage rpc secret'.
- [Setup WireGuard](./administrative-access.md#ssh-access) for hosts: `trinkgenossin`, optionally: `delite`, `blue-shell`

```
ssh <unix-username>@trinkgenossin.wg.pub.solar
```

```
# Add a few spaces to avoid leaking the secret to the shell history
   export GARAGE_RPC_SECRET=<secret-in-keepass>
```

Now, you can run the following command to check the cluster status:

```
garage status
```

Command to list all existing buckets:

```
garage bucket list
```

Creating a new bucket and access keys:

```
garage bucket create <bucket-name>
garage key create <bucket-name>-key
garage bucket allow <bucket-name> --read --write --key <bucket-name>-key
```

Full example for `mastodon` bucket:

```
garage bucket create mastodon

garage key create mastodon-key

garage bucket allow mastodon --read --write --key mastodon-key
```

Then [setup your favourite S3 client](https://garagehq.deuxfleurs.fr/documentation/connect/cli/)
or use the bucket with any [S3 compatible software](https://garagehq.deuxfleurs.fr/documentation/connect/).

Further reading:

- https://garagehq.deuxfleurs.fr/documentation/quick-start/
- https://garagehq.deuxfleurs.fr/documentation/connect/
- https://garagehq.deuxfleurs.fr/documentation/connect/apps/#mastodon

### Notes on manual setup steps

```
ssh <unix-username>@trinkgenossin.wg.pub.solar

# Add a few spaces to avoid leaking the secret to the shell history
    export GARAGE_RPC_SECRET=<secret-in-keepass>

# Uses the default config /etc/garage.toml
garage node id

garage node connect <node-id2>
garage node connect <node-id3>

garage status

#Zones
#DE-1 DE-2 NL-1

garage layout assign fdaa -z DE-1 -c 800G -t trinkgenossin
garage layout assign 8835 -z DE-2 -c 800G -t blue-shell
garage layout assign 73da -z NL-1 -c 800G -t delite
garage layout show
garage layout apply --version 1
```

Source: https://garagehq.deuxfleurs.fr/documentation/cookbook/real-world/#creating-a-cluster-layout
