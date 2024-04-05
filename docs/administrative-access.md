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
        }];

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

# Secret encryption

Deployment secrets are added to the repository in encrypted files. To be able to work with these encrypted files, your public key(s) will have to be added to your user attrset under `secretEncryptionKeys`.

See also the docs on [working with secrets](./secrets.md).
