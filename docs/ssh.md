# SSH Access

SSH Access is granted by adding a public key to [`public-keys/admins.nix`](../public-keys/admins.nix). This change will then have to be deployed to all hosts by an existing key. The keys will also grant access to the initrd SSH Server to enable remote unlock.
