# Deploying new versions

We use [deploy-rs](https://github.com/serokell/deploy-rs) to deploy changes. Currently this process is not automated, so configuration changes will have to be manually deployed.

To deploy, make sure you have a [working development shell](./development-shell.md). Then, run deploy-rs with the hostname of the server you want to deploy:

```
deploy '.#nachtigall'
```

You'll need to have SSH Access to the box to be able to do this.
