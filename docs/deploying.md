# Deploying new versions

We use [deploy-rs](https://github.com/serokell/deploy-rs) to deploy changes.
Currently this process is not automated, so configuration changes will have to
be manually deployed.

To deploy, make sure you have a [working development shell](./development-shell.md).
Then, run `deploy-rs` with the hostname of the server you want to deploy:

For nachtigall.pub.solar:

```
deploy --targets '.#nachtigall' --magic-rollback false --auto-rollback false --keep-result --result-path ./results
```

For flora-6.pub.solar:

```
deploy --targets '.#flora-6' --magic-rollback false --auto-rollback false --keep-result --result-path ./results
```

For metronom.pub.solar (aarch64-linux):

```
deploy --targets '.#metronom' --magic-rollback false --auto-rollback false --keep-result --result-path ./results --remote-build
```

Usually we skip all rollback functionality, but if you want to deploy a change
that might lock you out, e.g. to SSH, it might make sense to set these to `true`.

To skip flake checks, e.g. because you already ran them manually before
deployment, add the flag `--skip-checks` at the end of the command.

`--dry-activate` can be used to only put all files in place without switching,
to enable switching to the new config quickly at a later moment.

We use `--keep-result --result-path ./results` to keep the last `result`
symlink of each `deploy` from being garbage collected. That way, we keep builds
cached in the Nix store. This is optional and both flags can be removed if disk
space is a scarce resource on your machine.

You'll need to have SSH Access to the boxes to be able to run `deploy`.

### Getting SSH access

See [administrative-access.md](./administrative-access.md).
