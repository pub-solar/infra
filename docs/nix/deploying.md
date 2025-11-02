# Deploying new versions

We use [deploy-rs](https://github.com/serokell/deploy-rs) to deploy changes.
Currently this process is not automated, so configuration changes will have to
be manually deployed.

To deploy, make sure you have a [working development shell](./development-shell.md).
Then, run `deploy-rs` with the hostname of the server you want to deploy:

### Dry-run

Use `--dry-activate` to show a diff of updated packages and all services that
would be restarted by the update. This will also put all files in place without
switching to the new generation, enabling a quick switch to the new config at a
later moment.

For nachtigall.pub.solar:

```
deploy --targets '.#nachtigall' --ssh-user <unix-username> --magic-rollback false --auto-rollback false --keep-result --result-path ./results --dry-activate
```

After reviewing the changes, apply the update with:

```
deploy --targets '.#nachtigall' --ssh-user <unix-username> --magic-rollback false --auto-rollback false --keep-result --result-path ./results
```

For metronom.pub.solar (aarch64-linux):

```
deploy --targets '.#metronom' --ssh-user <unix-username> --magic-rollback false --auto-rollback false --keep-result --result-path ./results --remote-build
```

Usually we skip all rollback functionality, but if you want to deploy a change
that might lock you out, e.g. to SSH, it might make sense to set these to `true`.

To skip flake checks, e.g. because you already ran them manually before
deployment, add the flag `--skip-checks` at the end of the command.

We use `--keep-result --result-path ./results` to keep the last `result`
symlink of each `deploy` from being garbage collected. That way, we keep builds
cached in the Nix store. This is optional and both flags can be removed if disk
space is a scarce resource on your machine.

You'll need to have SSH Access to the boxes to be able to run `deploy`.

### Getting SSH access

See [administrative-access.md](./administrative-access.md).
