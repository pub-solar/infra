```
curl -L https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz | tar -xzf- -C /root
/root/kexec/run
```

```
mkdir -p /etc/secrets/initrd
ssh-keygen -t ed25519 -f /etc/secrets/initrd/ssh_host_ed25519_key
```

```
nix run github:nix-community/nixos-anywhere -- --flake .#blue-shell root@194.13.83.205
```
