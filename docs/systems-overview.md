# pub.solar Systems Overview

Last updated: 2025-03-11

Jump to:

1. [Server nachtigall](#server-nachtigall)
2. [Server metronom](#server-metronom)
3. [Server trinkgenossin](#server-trinkgenossin)
4. [Server blue-shell](#server-blue-shell)
5. [Server delite](#server-delite)
6. [Server tankstelle](#server-tankstelle)
7. [Server underground](#server-underground)
8. [Hetzner 1TB storagebox](#hetzner-1tb-storagebox)

### Server nachtigall

**Specs:**

- AMD Ryzen 7 3700X 8-Core Processor
- 64 GB RAM
- 4x 1TB NVMe disks

**Disk layout:**

- Encrypted ZFS mirror vdevs

**Operating System:**

- NixOS 24.11 `linux-x86_64`

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

### Server metronom

**Specs:**

- Hetzner VPS type: CAX11
- 2 vCPU
- 4 GB RAM
- 40GB disk

**Disk layout:**

- Encrypted ZFS single disk (stripe)

**Operating System:**

- NixOS 24.11 `linux-aach64`

**Usage:**
pub.solar mail server. Note this is an ARM server.

### Server trinkgenossin

**Specs:**

- Strato VPS type: VPS Linux VC8-32
- 8 core AMD EPYC-Milan Processor
- 32 GB RAM
- 1TB NVMe disk

**Disk layout:**

- Encrypted LUKS single disk

**Operating System:**

- NixOS 24.11 `linux-x86_64`

**Usage:**
Monitor, garage cluster node. Services:

- grafana
- loki
- prometheus
- garage
- forgejo-actions-runner (docker)

### Server blue-shell

**Specs:**

- netcup VPS type: VPS 1000 G11
- 4 core AMD EPYC-Rome Processor
- 8 GB RAM
- 256 GB SSD disk
- 850GB mechanical disk

**Disk layout:**

- Encrypted LVM on LUKS single disk and encrypted LUKS garage data disk

**Operating System:**

- NixOS 24.11 `linux-x86_64`

**Usage:**
Garage cluster node.

### Server delite

**Specs:**

- liteserver VPS type: HDD Storage VPS - HDD-2G
- 1 core AMD EPYC 7452
- 2 GB RAM
- 1TB mechanical disk

**Disk layout:**

- Encrypted LVM on LUKS single disk

**Operating System:**

- NixOS 24.11 `linux-x86_64`

**Usage:**
Garage cluster node.

### Server tankstelle

**Specs:**

- 24 core Intel Xeon E5-2670 v2 @ 2.50GHz
- 40 GB RAM
- 80GB SSD disk

**Disk layout:**

- LVM

**Operating System:**

- NixOS 24.11 `linux-x86_64`

**Usage:**

- forgejo-actions-runner (selfhosted, NixOS)

### Server underground

**Specs:**

- 8 core Intel Xeon E5-2670 v2 @ 2.50GHz
- 16 GB RAM
- 40 GB SSD disk

**Disk layout:**

- LVM on LUKS, single disk

**Operating System:**

- NixOS 24.11 `linux-x86_64`

**Usage:**
Testing server.

### Hetzner 1TB storagebox

**Usage:**
Backups get pushed to a Hetzner storagebox every night.
