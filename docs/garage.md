# Garage

### How-To create a new bucket + keys

Requirements:

- [Setup WireGuard](./administrative-access.md#ssh-access) for hosts: `trinkgenossin`, optionally: `delite`, `blue-shell`

```
ssh barkeeper@trinkgenossin.wg.pub.solar

export GARAGE_RPC_SECRET=<secret-in-keepass>

garage bucket create <bucket-name>
garage key create <bucket-name>-key
garage bucket allow <bucket-name> --read --write --key <bucket-name>-key
```

Docs: https://garagehq.deuxfleurs.fr/documentation/quick-start/#creating-buckets-and-keys

Then [setup your favourite S3 client](https://garagehq.deuxfleurs.fr/documentation/connect/cli/)
or use the bucket with any [S3 compatible software](https://garagehq.deuxfleurs.fr/documentation/connect/).

### Notes on manual setup steps

```
ssh barkeeper@trinkgenossin.wg.pub.solar

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
