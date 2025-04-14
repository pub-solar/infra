# pub.solar Systems Overview

Last updated: 2025-03-11

Jump to:

1. [Server nachtigall.pub.solar](#server-nachtigall-pub-solar)
2. [Server metronom.pub.solar](#server-metronom-pub-solar)
3. [Server trinkgenossin.pub.solar](#server-trinkgenossin-pub-solar)
4. [Server blue-shell.pub.solar](#server-blue-shell-pub-solar)
5. [Server delite.pub.solar](#server-delite-pub-solar)
6. [Server tankstelle.pub.solar](#server-tankstelle-pub-solar)
7. [Server underground.pub.solar](#server-underground-pub-solar)
8. [Hetzner 1TB storagebox](#hetzner-1tb-storagebox)

### Server nachtigall.pub.solar

**Specs:**

- AMD Ryzen 7 3700X 8-Core Processor
- 64 GB RAM
- 4x 1TB NVMe disks

**Disk layout:**

- Encrypted ZFS mirror vdevs

**Operating System:**

- NixOS 24.11 `x86_64-linux`

**Usage:**
Main pub.solar server. Hosts the majority of pub.solar services. Non-exhaustive list:

- collabora
- coturn
- forgejo
- keycloak
- mailman
- mastodon
- matrix-synapse (homeserver)
- mediawiki
- nextcloud
- owncast
- searx
- tmate
- tt-rss
- obs-portal

### Server metronom.pub.solar

**Specs:**

- Hetzner VPS type: CAX11
- 2 vCPU
- 4 GB RAM
- 40GB disk

**Disk layout:**

- Encrypted ZFS single disk (stripe)

**Operating System:**

- NixOS 24.11 `aarch64-linux`

**Usage:**
pub.solar mail server. Note this is an ARM server.

### Server trinkgenossin.pub.solar

**Specs:**

- Strato VPS type: VPS Linux VC8-32
- 8 core AMD EPYC-Milan Processor
- 32 GB RAM
- 1TB NVMe disk

**Disk layout:**

- Encrypted LUKS single disk

**Operating System:**

- NixOS 24.11 `x86_64-linux`

**Usage:**
Monitor, garage cluster node. Services:

- grafana
- loki
- prometheus
- garage
- forgejo-actions-runner (docker)

### Server blue-shell.pub.solar

**Specs:**

- netcup VPS type: VPS 1000 G11
- 4 core AMD EPYC-Rome Processor
- 8 GB RAM
- 256 GB SSD disk
- 850GB mechanical disk

**Disk layout:**

- Encrypted LVM on LUKS single disk and encrypted LUKS garage data disk

**Operating System:**

- NixOS 24.11 `x86_64-linux`

**Usage:**
Garage cluster node.

### Server delite.pub.solar

**Specs:**

- liteserver VPS type: HDD Storage VPS - HDD-2G
- 1 core AMD EPYC 7452
- 2 GB RAM
- 1TB mechanical disk

**Disk layout:**

- Encrypted LVM on LUKS single disk

**Operating System:**

- NixOS 24.11 `x86_64-linux`

**Usage:**
Garage cluster node.

### Server tankstelle.pub.solar

**Specs:**

- 24 core Intel Xeon E5-2670 v2 @ 2.50GHz
- 40 GB RAM
- 80GB SSD disk

**Disk layout:**

- LVM

**Operating System:**

- NixOS 24.11 `x86_64-linux`

**Usage:**

- forgejo-actions-runner (selfhosted, NixOS)

### Server underground.pub.solar

**Specs:**

- 8 core Intel Xeon E5-2670 v2 @ 2.50GHz
- 16 GB RAM
- 40 GB SSD disk

**Disk layout:**

- LVM on LUKS, single disk

**Operating System:**

- NixOS 24.11 `x86_64-linux`

**Usage:**
Testing server.

### Hetzner 1TB storagebox

Hostname:

```
u377325@u377325.your-storagebox.de
```

**Usage:**
Backups get pushed to a Hetzner storagebox every night.

### Garage cluster
