# Deploying new versions

We use [deploy-rs](https://github.com/serokell/deploy-rs) to deploy changes. Currently this process is not automated, so configuration changes will have to be manually deployed.

To deploy, make sure you have a [working development shell](./development-shell.md). Then, run `deploy-rs` with the hostname of the server you want to deploy:

For nachtigall.pub.solar:
```
deploy '.#nachtigall'
```

For flora-6.pub.solar:
```
deploy '.#flora-6'
```

You'll need to have SSH Access to the boxes to be able to do this.

### SSH access
Ensure your SSH public key is in place [here](./public-keys/admins.nix) and was deployed by someone with access.
