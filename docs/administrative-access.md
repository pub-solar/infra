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
2. **Wireguard device**: each wireguard device has two parts: the public key and the IP addresses it should have in the wireguard network. The pub.solar wireguard network is spaced under `10.7.6.0/24` and `fd00:fae:fae:fae:fae::/80`. To add your device, it's best to choose a free number between 200 and 255 and use that in both the ipv4 and ipv6 ranges: `10.7.6.<ip-address>/32` `fd00:fae:fae:fae:fae:<ip-address>::/96`. For more information on how to generate keypairs, see [the NixOS Wireguard docs](https://nixos.wiki/wiki/WireGuard#Generate_keypair).

One can access our hosts using this domain scheme:

```
ssh barkeeper@<hostname>.wg.pub.solar
```

So, for example for `nachtigall`:

```
ssh barkeeper@nachtigall.wg.pub.solar
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
          { # flora-6.pub.solar
            publicKey = "jtSR5G2P/nm9s8WrVc26Xc/SQLupRxyXE+5eIeqlsTU=";
            allowedIPs = [ "10.7.6.2/32" "fd00:fae:fae:fae:fae:2::/96" ];
            endpoint = "80.71.153.210:51820";
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
        ];
      };
    };
  };
}
```

# Secret encryption

Deployment secrets are added to the repository in encrypted files. To be able to work with these encrypted files, your public key(s) will have to be added to your user attrset under `secretEncryptionKeys`.

See also the docs on [working with secrets](./secrets.md).
