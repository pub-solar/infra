# The pub.solar infrastructure

This repository contains almost all of the configuration for the whole pub.solar infrastructure. Our goal is to have everything, from host configurations to Terraform DNS in this repository.

The architecture we are working towards is a vast simplification of what it was before: one dedicated Hetzner server running [NixOS](https://nixos.org/) with all services. Offsite backups go to several different locations with [restic](https://github.com/restic/restic).

## Contributing

If you'd like to contribute, it makes sense to talk to the crew on Matrix via [#hakken](https://matrix.to/#/#hakken:pub.solar?via=chat.pub.solar). We can help figuring out how things work and can make sure your ideas fit the pub.solar philosophy. Of course [popping a pull request](https://forgejo.org/docs/latest/user/pull-requests-and-git-flow/) is always celebrated.

To start, check our [contributing guide](./CONTRIBUTING.md).
