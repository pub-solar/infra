# Unlocking the ZFS pool on boot

After a reboot, the encrypted ZFS pool will have to be unlocked. This is done by
accessing the server via SSH as user `root` on port 2222.

Nachtigall:

```
ssh root@nachtigall.pub.solar -p2222
```

Metronom:

```
ssh root@metronom.pub.solar -p2222
```

After connecting, paste the encryption passphrase you can find in the shared
keepass. This will disconnect the SSH session immediately and the server will
continue to boot into stage 2.
