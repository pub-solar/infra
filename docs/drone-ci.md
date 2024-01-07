# Drone CI

We currently use two CI systems, [drone CI](https://drone.io), reachable via
https://ci.pub.solar and [Forgejo Actions](https://forgejo.org/docs/latest/user/actions/),
which UI is integrated into https://git.pub.solar, for example
https://git.pub.solar/pub-solar/infra/actions.

### Signing the `.drone.yml` file

Login to https://ci.pub.solar by clicking on the user icon in the bottom left.
After logging in, you can view your personal API token by clicking on the same
icon. If you're using the nix [development-shell](./development-shell.md), the
`drone` command will already be installed.

```
export DRONE_TOKEN=<your-drone-api-token>

drone --token $DRONE_TOKEN sign --save pub-solar/os
```
