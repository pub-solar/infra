# Adminstrative access

People with admin access to the infrastructure are added to [`logins/admins.nix`](../logins/admins.nix). This is a attrset with the following structure:

```
{
    <username> = {
        sshPubKeys = {
            <name> = <pubkey-string>;
        };

        wireguardDevices = [
            {
                publicKey = <pubkey-string>;
                allowedIPs = [ "10.7.6.<ip-address>/32" "fd00:fae:fae:fae:fae:<ip-address>::/96" ];
            }
        ];

        secretEncryptionKeys = {
            <name> = <encryption-key-string>;
        };
    };
}
```

# SSH Access

SSH is not reachable from the open internet. Instead, SSH Port 22 is protected by a wireguard VPN network. Thus, to get root access on the servers, at least two pieces of information have to be added to the admins config:

1. **SSH Public key**: self-explanatory. Add your public key to your user attrset under `sshPubKeys`.
2. **Wireguard device**: each wireguard device has two parts: the public key and the IP addresses it should have in the wireguard network. The pub.solar wireguard network uses the subnets `10.7.6.0/24` and `fd00:fae:fae:fae:fae::/80`. To add your device, it's best to choose a free number between 200 and 255 and use that in both the ipv4 and ipv6 ranges: `10.7.6.<ip-address>/32` `fd00:fae:fae:fae:fae:<ip-address>::/96`. For more information on how to generate keypairs, see [the NixOS Wireguard docs](https://nixos.wiki/wiki/WireGuard#Generate_keypair).

One can access our hosts using this domain scheme:

```
ssh <unix-username>@<hostname>.wg.pub.solar
```

So, for example for `nachtigall`:

```
ssh teutat3s@nachtigall.wg.pub.solar
```

Example NixOS snippet for WireGuard client config

```
{
  networking = {
    wireguard.enable = true;
    wg-quick.interfaces = {
      wg-pub-solar = {
        address = ["10.7.6.201/32"];
        address = ["10.7.6.201/32" "fd00:fae:fae:fae:fae:201::/96"];
        privateKeyFile = "/etc/wireguard/wg-pub-solar.privatekey";

        peers = [
          { # nachtigall.pub.solar
            publicKey = "qzNywKY9RvqTnDO8eLik75/SHveaSk9OObilDzv+xkk=";
            allowedIPs = [ "10.7.6.1/32" "fd00:fae:fae:fae:fae:1::/96" ];
            endpoint = "[2a01:4f8:172:1c25::1]:51820";
            # Use this endpoint in IPv4 only networks
            #endpoint = "138.201.80.102:51820";
            persistentKeepalive = 15;
          }
          { # metronom.pub.solar
            publicKey = "zOSYGO7MfnOOUnzaTcWiKRQM0qqxR3JQrwx/gtEtHmo=";
            allowedIPs = [ "10.7.6.3/32" "fd00:fae:fae:fae:fae:3::/96" ];
            #endpoint = "[2a01:4f8:c2c:7082::]:51820";
            # Use this endpoint in IPv4 only networks
            endpoint = "49.13.236.167:51820";
            persistentKeepalive = 15;
          }
          { # tankstelle.pub.solar
            publicKey = "iRTlY1lB7nPXf2eXzX8ZZDkfMmXyGjff5/joccbP8Cg=";
            allowedIPs = [ "10.7.6.4/32" "fd00:fae:fae:fae:fae:4::/96" ];
            endpoint = "[2001:4d88:1ffa:26::5]:51820";
            # Use this endpoint in IPv4 only networks
            #endpoint = "80.244.242.5:51820";
            persistentKeepalive = 15;
          }
          {
            # trinkgenossin.pub.solar
            publicKey = "QWgHovHxtqiQhnHLouSWiT6GIoQDmuvnThYL5c/rvU4=";
            allowedIPs = [
              "10.7.6.5/32"
              "fd00:fae:fae:fae:fae:5::/96"
            ];
            #endpoint = "85.215.152.22:51820";
            endpoint = "[2a01:239:35d:f500::1]:51820";
            persistentKeepalive = 15;
          }
          {
            # delite.pub.solar
            publicKey = "ZT2qGWgMPwHRUOZmTQHWCRX4m14YwOsiszjsA5bpc2k=";
            allowedIPs = [
              "10.7.6.6/32"
              "fd00:fae:fae:fae:fae:6::/96"
            ];
            #endpoint = "5.255.119.132:51820";
            endpoint = "[2a04:52c0:124:9d8c::2]:51820";
            persistentKeepalive = 15;
          }
          {
            # blue-shell.pub.solar
            publicKey = "bcrIpWrKc1M+Hq4ds3aN1lTaKE26f2rvXhd+93QrzR8=";
            allowedIPs = [
              "10.7.6.7/32"
              "fd00:fae:fae:fae:fae:7::/96"
            ];
            #endpoint = "194.13.83.205:51820";
            endpoint = "[2a03:4000:43:24e::1]:51820";
            persistentKeepalive = 15;
          }
        ];
      };
    };
  };
}
```

# Secret encryption

Deployment secrets are added to the repository in encrypted files. To be able to work with these encrypted files, your public key(s) will have to be added to your user attrset under `secretEncryptionKeys`.

See also the docs on [working with secrets](./secrets.md).
