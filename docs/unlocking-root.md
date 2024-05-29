# Unlocking the root partition on boot

After a reboot, the encrypted ZFS pool will have to be unlocked. This is done by accessing the server via SSH with user `root` on port 2222.

Nachtigall:

```
ssh root@138.201.80.102 -p2222
```

Metronom:

```
ssh root@49.13.236.167 -p2222
```

After connecting, paste the crypt passphrase you can find in the shared keepass. This will disconnect the SSH session right away and the server will keep booting into stage 2.
