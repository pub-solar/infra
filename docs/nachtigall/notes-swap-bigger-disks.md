# Notes on swapping two disks in server nachtigall for bigger disks

To increase disks in ZFS `mirror-1` from 1TB to 2TB disks, we first swap a single disk and let it sync the data (resilver in ZFS terminology).

Disk layout before swapping the first disk:

```
teutat3s in 🌐 nachtigall in ~
❯ sudo zpool status
  pool: root_pool
 state: ONLINE
status: Some supported and requested features are not enabled on the pool.
	The pool can still be used, but some features are unavailable.
action: Enable all features using 'zpool upgrade'. Once this is done,
	the pool may no longer be accessible by software that does not support
	the features. See zpool-features(7) for details.
  scan: scrub repaired 0B in 00:13:42 with 0 errors on Wed Apr  1 03:36:43 2026
config:

	NAME                                                      STATE     READ WRITE CKSUM
	root_pool                                                 ONLINE       0     0     0
	  mirror-0                                                ONLINE       0     0     0
	    nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NF0R517371-part3  ONLINE       0     0     0
	    nvme-KXG60ZNV1T02_TOSHIBA_Z9NF704ZF9ZL-part3          ONLINE       0     0     0
	  mirror-1                                                ONLINE       0     0     0
	    nvme-SAMSUNG_MZVL21T0HDLU-00B07_S77WNF0XA01902-part3  ONLINE       0     0     0
	    nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NU0W623944-part3  ONLINE       0     0     0

errors: No known data errors
```

```
teutat3s in 🌐 nachtigall in ~
❯ lsblk -f
NAME        FSTYPE     FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
nvme0n1
├─nvme0n1p1
├─nvme0n1p2 vfat       FAT16           5494-BA1E                             312.3M    36% /boot2
└─nvme0n1p3 zfs_member 5000  root_pool 8287701206764130981
nvme1n1
├─nvme1n1p1
├─nvme1n1p2 vfat       FAT32           5493-EFF5                               1.7G     9% /boot1
└─nvme1n1p3 zfs_member 5000  root_pool 8287701206764130981
nvme3n1
├─nvme3n1p1
├─nvme3n1p2 vfat       FAT32           E76C-A8A0                               1.7G     9% /boot4
└─nvme3n1p3 zfs_member 5000  root_pool 8287701206764130981
nvme2n1
├─nvme2n1p1
├─nvme2n1p2 vfat       FAT32           E4E4-88C7                               1.7G     9% /boot3
└─nvme2n1p3 zfs_member 5000  root_pool 8287701206764130981
```

### Troubleshooting boot issue after the disk was swapped

```
ssh -4 root@nachtigall.pub.solar -p 2222

zpool status # no pools
zpool import # get pool id
zpool import <pool-id>

# Decrypt ZFS datasets
zfs load-key -a

# Server should continue boot process
exit
```

Server didn't want to boot because:

```
Timed out waiting for device /dev/disk/by-uuid/E4E4-88C7.
```

NixOS forum to the rescue: https://discourse.nixos.org/t/nixos-went-to-systemd-emergency-mode/5647/11?u=teutat3s

```
mount -o remount,rw /nix/store
vim /etc/fstab # comment out broken line
# ctrl+d # it boots
```

### Replace missing disk with new, bigger disk

Partition new disk

```
teutat3s in 🌐 nachtigall in ~
❯ sudo fdisk /dev/nvme2n1

Welcome to fdisk (util-linux 2.41.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/nvme2n1: 1.86 TiB, 2048408248320 bytes, 4000797360 sectors
Disk model: Micron_3500_MTFDKBA2T0TGD-1BK1AABYY
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 55E0FD7E-442F-5442-8540-8317D193BA3A

Device              Start        End    Sectors  Size Type
/dev/nvme2n1p1       2048 4000780287 4000778240  1.9T Solaris /usr & Apple ZFS
/dev/nvme2n1p9 4000780288 4000796671      16384    8M Solaris reserved 1

Command (m for help): g
Created a new GPT disklabel (GUID: A0E71ACC-15D0-4C23-BFD8-0CCB974D4106).

Command (m for help): n
Partition number (1-128, default 1):
First sector (2048-4000797326, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-4000797326, default 4000796671): 4095

Created a new partition 1 of type 'Linux filesystem' and of size 1 MiB.

Command (m for help): t
Selected partition 1
Partition type or alias (type L to list all): 4
Changed type of partition 'Linux filesystem' to 'BIOS boot'.

Command (m for help): n
Partition number (2-128, default 2):
First sector (4096-4000797326, default 4096):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4096-4000797326, default 4000796671): 3901440

Created a new partition 2 of type 'Linux filesystem' and of size 1.9 GiB.

Command (m for help): t
Partition number (1,2, default 2):
Partition type or alias (type L to list all): 1

Changed type of partition 'Linux filesystem' to 'EFI System'.

Command (m for help): n
Partition number (3-128, default 3):
First sector (3901441-4000797326, default 3903488):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (3903488-4000797326, default 4000796671):

Created a new partition 3 of type 'Linux filesystem' and of size 1.9 TiB.

Command (m for help): p
Disk /dev/nvme2n1: 1.86 TiB, 2048408248320 bytes, 4000797360 sectors
Disk model: Micron_3500_MTFDKBA2T0TGD-1BK1AABYY
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: A0E71ACC-15D0-4C23-BFD8-0CCB974D4106

Device           Start        End    Sectors  Size Type
/dev/nvme2n1p1    2048       4095       2048    1M BIOS boot
/dev/nvme2n1p2    4096    3901440    3897345  1.9G EFI System
/dev/nvme2n1p3 3903488 4000796671 3996893184  1.9T Linux filesystem

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

teutat3s in 🌐 nachtigall in ~
❯ sudo mkfs.vfat /dev/nvme2n1p2
mkfs.fat 4.2 (2021-01-31)
```

```
# Check missing disk id
sudo zpool status

# Check for new device id, here nvme-Micron_3500...
ls /dev/disk/by-id

# Replace disk
sudo zpool replace root_pool 17913141396623227287 /dev/disk/by-id/nvme-Micron_3500_MTFDKBA2T0TGD-1BK1AABYY_252350A44C85-part3
```

View status of resilvering

```
teutat3s in 🌐 nachtigall in ~
❯ sudo zpool status
  pool: root_pool
 state: DEGRADED
status: One or more devices is currently being resilvered.  The pool will
	continue to function, possibly in a degraded state.
action: Wait for the resilver to complete.
  scan: resilver in progress since Sun Apr 19 15:44:14 2026
	1.28T / 1.28T scanned, 148G / 526G issued at 969M/s
	149G resilvered, 28.24% done, 00:06:38 to go
config:

	NAME                                                               STATE     READ WRITE CKSUM
	root_pool                                                          DEGRADED     0     0     0
	  mirror-0                                                         ONLINE       0     0     0
	    nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NF0R517371-part3           ONLINE       0     0     0
	    nvme-KXG60ZNV1T02_TOSHIBA_Z9NF704ZF9ZL-part3                   ONLINE       0     0     0
	  mirror-1                                                         DEGRADED     0     0     0
	    replacing-0                                                    DEGRADED     1     0     0
	      17913141396623227287                                         UNAVAIL      0     0     0  was /dev/disk/by-id/nvme-SAMSUNG_MZVL21T0HDLU-00B07_S77WNF0XA01902-part3
	      nvme-Micron_3500_MTFDKBA2T0TGD-1BK1AABYY_252350A44C85-part3  ONLINE       0     0     0  (resilvering)
	    nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NU0W623944-part3           ONLINE       0     0     0

errors: No known data errors
```
