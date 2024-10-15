# Nextcloud debugging

Set loglevel to `0` for debug logs:

```nix
services.nextcloud.settings.loglevel = 0;
```

Then, logs appear in the `phpfpm-nextcloud.service` logs:

```bash
sudo journalctl -fu phpfpm-nextcloud
```

Make sure to set the loglevel back to the default `2` warning after debugging:

```nix
services.nextcloud.settings.loglevel = 2;
```
