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
