Use these commands to show the diff between versions for planning updates:

```
OLD_CLOSURE=$(nix build --print-out-paths .#nixosConfigurations.nachtigall.config.system.build.toplevel)
/nix/store/c6wqp1vzvyr3bq2igd8p460613ddwrmj-nixos-system-nachtigall-23.11.20231201.5de0b32
```

```
nix flake update
...
```

```
NEW_CLOSURE=$(nix build --print-out-paths .#nixosConfigurations.nachtigall.config.system.build.toplevel)
/nix/store/xynyf943d2nw1wgawhzxh13xkkf1whb0-nixos-system-nachtigall-23.11.20231210.781e2a9
```

```
nix store diff-closures $OLD_CLOSURE $NEW_CLOSURE
cpupower: 6.1.64 → 6.1.66
element-web: 1.11.47 → 1.11.51, +5325.9 KiB
element-web-wrapped: 1.11.47 → 1.11.51
initrd-linux: 6.1.64 → 6.1.66
keycloak: 22.0.5 → 23.0.0, +15201.4 KiB
linux: 6.1.64, 6.1.64-modules → 6.1.66, 6.1.66-modules, +8.3 KiB
mastodon: 4.2.1 → 4.2.3, +16.3 KiB
mastodon-gems: 4.2.1 → 4.2.3, +14.4 KiB
mastodon-modules: 4.2.1 → 4.2.3
nix: +18.8 KiB
nixos-manual: +73.6 KiB
nixos-system-nachtigall: 23.11.20231201.5de0b32 → 23.11.20231210.781e2a9
opensearch: 2.11.0 → 2.11.1, +560.5 KiB
owncast: 0.1.1 → 0.1.2, +798.9 KiB
ruby3.2.2-bcp47_spec: ∅ → 0.2.1, +13.6 KiB
ruby3.2.2-json-canonicalization: 0.3.2 → 1.0.0
ruby3.2.2-json-ld: 3.2.5 → 3.3.1
ruby3.2.2-rdf: 3.2.11 → 3.3.1
samba: +12.5 KiB
source: +3888.1 KiB
wrapped-ruby-mastodon-gems: 4.2.1 → 4.2.3
zfs-kernel: 2.2.1-6.1.64 → 2.2.2-6.1.66
zfs-user: 2.2.1 → 2.2.2
```

### Deploying updates

See [deploying.md](./deploying.md).
