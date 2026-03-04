# Matrix reactivate account

If a user accidentially deletes (deactivates) their matrix account, these are the steps to reactivate the account.

SSH to `nachtigall`.

First, get the latest paths to `matrix-authentication-service` CLI `mas-cli`
and configs from its systemd service. These change frequently and we don't have
a wrapper command yet.

```
sudo systemctl cat matrix-authentication-service.service
```

Adapt this example command for account `@<username>:pub.solar`, replacing `<username>` with the one you would like to reactivate:

```
sudo -u matrix-authentication-service \
  /nix/store/djwlmfh5gkgg1qby6fvjr0hx1x011xsi-matrix-authentication-service-1.11.0/bin/mas-cli \
    --config /nix/store/0jjnpy4p5ryxylhvac4ld3pg4irap2ns-config.yaml \
    --config /run/agenix/matrix-authentication-service-secret-config.yml \
    manage unlock-user --reactivate <username>
```

Docs: https://element-hq.github.io/matrix-authentication-service/reference/cli/manage.html#manage-unlock-user
