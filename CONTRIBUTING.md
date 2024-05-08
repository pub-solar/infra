# Contributing guide

Things you'll need:

- To create [Pull Requests](https://forgejo.org/docs/latest/user/pull-requests-and-git-flow/), you will need to register your [pub.solar ID](https://auth.pub.solar) first.
- For small changes, e.g. to documentation, you can directly edit files in the browser.

### Getting a development shell

First, get a local copy of this repository:

```
git clone https://git.pub.solar/pub-solar/infra.git
cd infra
```

then, install [the package manager nix](https://nixos.org/download).

Finally, run:

```
nix develop
```

This will install a development shell (devshell) with all required tools.

### Final checks before creating a Pull Request

Before creating a pull request, it's recommended to check the formatting:

```
treefmt
```

If you are a terminal-lover, the [AGit alternative](https://forgejo.org/docs/latest/user/agit-support/) to the web based Pull Request workflow might be interesting.
