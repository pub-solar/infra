# Deploying with nixos-anywhere

## On Target: Enter NixOS from non-NixOS host

In case you cannot boot easily into a nixos-installer image you can download the kexec installer image of NixOS and kexec into it:

```
curl -L https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz | tar -xzf- -C /root
/root/kexec/run
```

## Run Disko

```
nix run github:nix-community/nixos-anywhere -- --flake .#<hostname> --target-host root@<host> --phases disko
```

## On Target: Create inital ssh host key used in initrd

```
mkdir -p /mnt/etc/secrets/initrd
ssh-keygen -t ed25519 -f /mnt/etc/secrets/initrd/ssh_host_ed25519_key
```

## Run NixOS Anywhere

```
nix run github:nix-community/nixos-anywhere -- --flake .#<hostname> --target-host root@<host> --phases install,reboot
```
