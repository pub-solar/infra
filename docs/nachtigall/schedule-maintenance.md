# How to schedule a maintenance

`nachtigall` is a dedicated Hetzner server, managed via https://robot.hetzner.com/server.

We'll use a [hardware upgrade](https://docs.hetzner.com/robot/dedicated-server/dedicated-server-hardware/price-server-addons/) as an example:

1. Select the server in the [list](https://robot.hetzner.com/server)
1. Click `Support` -> `Select server support topic` -> `Technical`
1. Click `Server - Hardware Upgrade`
1. Choose the desired appointment time and draft a message, similar to the below example

Example text for a disk upgrade request:

```
Hello Hetzner Support team,

I'd like to request to upgrade a 1TB NVMe SSDs Add-on disk to a 2 TB NVMe SSD.
Serial number of the drive: nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NU0W623944
I accept its data loss.

Please confirm if the preferred appointment is available.

Kind regards
<name>
```

One minute prior to the scheduled maintenance, remember to power off the server with:

```
sudo systemctl poweroff
```

This ensures a clean shutdown and can slightly speed up the maintenance.

Further reading:

- [Hetzner docs: Upgrades for dedicated servers](https://docs.hetzner.com/robot/dedicated-server/dedicated-server-hardware/dedicated-server-upgrade)
