# Unlocking the root partition on boot

After a boot, the encrypted root partition will have to be unlocked. This is done by accessing the server via SSH on port 2222. After connecting, paste the crypt passphrase you can find in the shared keepass. This will disconnect the SSH session right away and the server will keep booting into stage 2.
