# Cachix usage

URL: https://pub-solar.cachix.org

Requirements:

- [Install cachix](https://docs.cachix.org/installation)
- Optional: To push to the cache, you need to set `CACHIX_AUTH_TOKEN` in your environment
- Add our binary cache [to your nix config](https://docs.cachix.org/faq#cachix-use-effects). To add the pub-solar cache, run:

```
cachix use pub-solar
```

Example to build and push a custom package of a host in this flake (e.g. after creating an overlay):

```
nix build --json -f . '.#nixosConfigurations.nachtigall.pkgs.keycloak^*' \
  | jq -r '.[].outputs | to_entries[].value' \
  | cachix push pub-solar
```

Example to build and push a package in the `nixpkgs` repo:

```
cd nixpkgs
nix build --json -f . 'pkgs.lix^*' \
  | jq -r '.[].outputs | to_entries[].value' \
  | cachix push pub-solar
```

Checking if a package has been correctly pushed to the cache:

```
❯ nix build --json '/nix/store/f76xi83z4xk9sn6pbh38rh97yvqhb5m0-noto-fonts-color-emoji-png-2.042.drv^*' | jq -r '.[].outputs | to_entries[].value'  | cachix push pub-solar
Pushing 1 paths (0 are already present) using zstd to cache pub-solar ⏳

✓ /nix/store/xpgpi84765dxqja3gd5pldj49xx2v0xl-noto-fonts-color-emoji-png-2.042 (10.30 MiB)

All done.

❯ curl -I https://pub-solar.cachix.org/xpgpi84765dxqja3gd5pldj49xx2v0xl.narinfo
HTTP/2 200
date: Mon, 26 Aug 2024 09:31:10 GMT
content-type: text/x-nix-narinfo
traceparent: 00-b99db37cc9c2581b8d226cdf81e54507-794fc49193659c03-01
tracestate:
cache-control: public, max-age=14400
last-modified: Mon, 26 Aug 2024 09:31:10 GMT
cf-cache-status: EXPIRED
report-to: {"endpoints":[{"url":"https:\/\/a.nel.cloudflare.com\/report\/v4?s=A67KGsCIsYjoFdvndxJ0rkmb7BZ5ztIpm8WUJKAiUPRVWvbYeXU9gU27P7zryiUtArbwrLzHhhMija0yyXk0kwNa3suz8gNzKK6z1CX1FWDZiiP07rnq7zAg8nZbSBiEU%2FZrU9nSrR6mhuL9ihbmW1Hf"}],"group":"cf-nel","max_age":604800}
nel: {"success_fraction":0,"report_to":"cf-nel","max_age":604800}
server: cloudflare
cf-ray: 8b92ceab0d19c80e-DUS
```
