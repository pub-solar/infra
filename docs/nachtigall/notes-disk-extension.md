# Notes on adding two disks to server nachtigall

Status after Hetzner support added two additional 1TB NVMe disks:

```
teutat3s in 🌐 nachtigall in ~
❯ lsblk -f
NAME        FSTYPE     FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
nvme0n1
├─nvme0n1p1
├─nvme0n1p2 vfat       FAT16           5494-BA1E                               385M    21% /boot2
└─nvme0n1p3 zfs_member 5000  root_pool 8287701206764130981
nvme1n1
├─nvme1n1p1
├─nvme1n1p2 vfat       FAT32           5493-EFF5                               1.8G     5% /boot1
└─nvme1n1p3 zfs_member 5000  root_pool 8287701206764130981
nvme2n1
nvme3n1

teutat3s in 🌐 nachtigall in ~
❯ sudo fdisk -l /dev/nvme0n1
Disk /dev/nvme0n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
Disk model: KXG60ZNV1T02 TOSHIBA
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 28F8681A-4559-4801-BF3F-BFEC8058236B

Device          Start        End    Sectors   Size Type
/dev/nvme0n1p1   2048       4095       2048     1M BIOS boot
/dev/nvme0n1p2   4096     999423     995328   486M EFI System
/dev/nvme0n1p3 999424 2000408575 1999409152 953.4G Linux filesystem

teutat3s in 🌐 nachtigall in ~
❯ sudo fdisk -l /dev/nvme1n1
Disk /dev/nvme1n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
Disk model: SAMSUNG MZVL21T0HCLR-00B00
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: A143A806-69C5-4EFC-8E34-20C35574D990

Device           Start        End    Sectors  Size Type
/dev/nvme1n1p1    2048       4095       2048    1M BIOS boot
/dev/nvme1n1p2    4096    3905535    3901440  1.9G EFI System
/dev/nvme1n1p3 3905536 2000408575 1996503040  952G Linux filesystem

teutat3s in 🌐 nachtigall in ~
❯ sudo fdisk -l /dev/nvme2n1
Disk /dev/nvme2n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
Disk model: SAMSUNG MZVL21T0HDLU-00B07
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

teutat3s in 🌐 nachtigall in ~
❯ sudo fdisk -l /dev/nvme3n1
Disk /dev/nvme3n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
Disk model: SAMSUNG MZVL21T0HCLR-00B00
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

Partitioning and formatting the new disks `/dev/nvme2n1` and `/dev/nvme3n1`:

```
teutat3s in 🌐 nachtigall in ~
❯ sudo fdisk /dev/nvme2n1

Welcome to fdisk (util-linux 2.39.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0x0852470c.

Command (m for help): p
Disk /dev/nvme2n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
Disk model: SAMSUNG MZVL21T0HDLU-00B07
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x0852470c

Command (m for help): m

Help:

  DOS (MBR)
   a   toggle a bootable flag
   b   edit nested BSD disklabel
   c   toggle the dos compatibility flag

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   u   change display/entry units
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty MBR (DOS) partition table
   s   create a new empty Sun partition table


Command (m for help): g
Created a new GPT disklabel (GUID: 8CC98E3F-20A8-4A2D-8D50-9CD769EE4C65).

Command (m for help): p
Disk /dev/nvme2n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
Disk model: SAMSUNG MZVL21T0HDLU-00B07
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 8CC98E3F-20A8-4A2D-8D50-9CD769EE4C65

Command (m for help): n
Partition number (1-128, default 1):
First sector (2048-2000409230, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-2000409230, default 2000408575): 4095

Created a new partition 1 of type 'Linux filesystem' and of size 1 MiB.

Command (m for help): t
Selected partition 1
Partition type or alias (type L to list all): L
  1 EFI System                     C12A7328-F81F-11D2-BA4B-00A0C93EC93B
  2 MBR partition scheme           024DEE41-33E7-11D3-9D69-0008C781F39F
  3 Intel Fast Flash               D3BFE2DE-3DAF-11DF-BA40-E3A556D89593
  4 BIOS boot                      21686148-6449-6E6F-744E-656564454649
  5 Sony boot partition            F4019732-066E-4E12-8273-346C5641494F
  6 Lenovo boot partition          BFBFAFE7-A34F-448A-9A5B-6213EB736C22
  7 PowerPC PReP boot              9E1A2D38-C612-4316-AA26-8B49521E5A8B
  8 ONIE boot                      7412F7D5-A156-4B13-81DC-867174929325
  9 ONIE config                    D4E6E2CD-4469-46F3-B5CB-1BFF57AFC149
 10 Microsoft reserved             E3C9E316-0B5C-4DB8-817D-F92DF00215AE
 11 Microsoft basic data           EBD0A0A2-B9E5-4433-87C0-68B6B72699C7
 12 Microsoft LDM metadata         5808C8AA-7E8F-42E0-85D2-E1E90434CFB3
 13 Microsoft LDM data             AF9B60A0-1431-4F62-BC68-3311714A69AD
 14 Windows recovery environment   DE94BBA4-06D1-4D40-A16A-BFD50179D6AC
 15 IBM General Parallel Fs        37AFFC90-EF7D-4E96-91C3-2D7AE055B174
 16 Microsoft Storage Spaces       E75CAF8F-F680-4CEE-AFA3-B001E56EFC2D
 17 HP-UX data                     75894C1E-3AEB-11D3-B7C1-7B03A0000000
 18 HP-UX service                  E2A1E728-32E3-11D6-A682-7B03A0000000
 19 Linux swap                     0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
 20 Linux filesystem               0FC63DAF-8483-4772-8E79-3D69D8477DE4
...
Partition type or alias (type L to list all): 4
Changed type of partition 'Linux filesystem' to 'BIOS boot'.

Command (m for help): n
Partition number (2-128, default 2):
First sector (4096-2000409230, default 4096):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4096-2000409230, default 2000408575): 3901440

Created a new partition 2 of type 'Linux filesystem' and of size 1.9 GiB.

Command (m for help): t
Partition number (1,2, default 2): 2
Partition type or alias (type L to list all): 1

Changed type of partition 'Linux filesystem' to 'EFI System'.

Command (m for help): n
Partition number (3-128, default 3):
First sector (3901441-2000409230, default 3903488):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (3903488-2000409230, default 2000408575):

Created a new partition 3 of type 'Linux filesystem' and of size 952 GiB.

Command (m for help): p
Disk /dev/nvme2n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
Disk model: SAMSUNG MZVL21T0HDLU-00B07
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 8CC98E3F-20A8-4A2D-8D50-9CD769EE4C65

Device           Start        End    Sectors  Size Type
/dev/nvme2n1p1    2048       4095       2048    1M BIOS boot
/dev/nvme2n1p2    4096    3901440    3897345  1.9G EFI System
/dev/nvme2n1p3 3903488 2000408575 1996505088  952G Linux filesystem

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.


teutat3s in 🌐 nachtigall in ~ took 5m41s
❯ sudo fdisk /dev/nvme3n1

Welcome to fdisk (util-linux 2.39.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0xa77eb504.

Command (m for help): g
Created a new GPT disklabel (GUID: 56B64CEE-5E0C-4EAA-AE2F-5BF4356183A5).

Command (m for help): n
Partition number (1-128, default 1):
First sector (2048-2000409230, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-2000409230, default 2000408575): 4095

Created a new partition 1 of type 'Linux filesystem' and of size 1 MiB.

Command (m for help): t
Selected partition 1
Partition type or alias (type L to list all): 4
Changed type of partition 'Linux filesystem' to 'BIOS boot'.

Command (m for help): n
Partition number (2-128, default 2):
First sector (4096-2000409230, default 4096):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4096-2000409230, default 2000408575): 3901440

Created a new partition 2 of type 'Linux filesystem' and of size 1.9 GiB.

Command (m for help): t
Partition number (1,2, default 2): 2
Partition type or alias (type L to list all): 1

Changed type of partition 'Linux filesystem' to 'EFI System'.

Command (m for help): n
Partition number (3-128, default 3):
First sector (3901441-2000409230, default 3903488):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (3903488-2000409230, default 2000408575):

Created a new partition 3 of type 'Linux filesystem' and of size 952 GiB.

Command (m for help): p
Disk /dev/nvme3n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
Disk model: SAMSUNG MZVL21T0HCLR-00B00
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 56B64CEE-5E0C-4EAA-AE2F-5BF4356183A5

Device           Start        End    Sectors  Size Type
/dev/nvme3n1p1    2048       4095       2048    1M BIOS boot
/dev/nvme3n1p2    4096    3901440    3897345  1.9G EFI System
/dev/nvme3n1p3 3903488 2000408575 1996505088  952G Linux filesystem

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

teutat3s in 🌐 nachtigall in ~
❯ sudo mkfs.vfat /dev/nvme2n1p2
mkfs.fat 4.2 (2021-01-31)

teutat3s in 🌐 nachtigall in ~
❯ sudo mkfs.vfat /dev/nvme3n1p2
mkfs.fat 4.2 (2021-01-31)

teutat3s in 🌐 nachtigall in ~
❯ lsblk -f
NAME        FSTYPE     FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
nvme0n1
├─nvme0n1p1
├─nvme0n1p2 vfat       FAT16           5494-BA1E                               385M    21% /boot2
└─nvme0n1p3 zfs_member 5000  root_pool 8287701206764130981
nvme1n1
├─nvme1n1p1
├─nvme1n1p2 vfat       FAT32           5493-EFF5                               1.8G     5% /boot1
└─nvme1n1p3 zfs_member 5000  root_pool 8287701206764130981
nvme2n1
├─nvme2n1p1
├─nvme2n1p2 vfat       FAT32           E4E4-88C7
└─nvme2n1p3
nvme3n1
├─nvme3n1p1
├─nvme3n1p2 vfat       FAT32           E76C-A8A0
└─nvme3n1p3
```

Finally, adding the new drives to the ZFS zpool `root_pool` to extend available disk space:

```
teutat3s in 🌐 nachtigall in ~
❯ sudo zpool status
  pool: root_pool
 state: ONLINE
  scan: scrub repaired 0B in 00:17:47 with 0 errors on Sat Mar  1 03:35:20 2025
config:

	NAME                                                      STATE     READ WRITE CKSUM
	root_pool                                                 ONLINE       0     0     0
	  mirror-0                                                ONLINE       0     0     0
	    nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NF0R517371-part3  ONLINE       0     0     0
	    nvme-KXG60ZNV1T02_TOSHIBA_Z9NF704ZF9ZL-part3          ONLINE       0     0     0

errors: No known data errors

teutat3s in 🌐 nachtigall in ~
❯ sudo zpool add root_pool mirror nvme-SAMSUNG_MZVL21T0HDLU-00B07_S77WNF0XA01902-part3 nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NU0W623944-part3

teutat3s in 🌐 nachtigall in ~
❯ sudo zpool status
  pool: root_pool
 state: ONLINE
  scan: scrub repaired 0B in 00:17:47 with 0 errors on Sat Mar  1 03:35:20 2025
config:

	NAME                                                      STATE     READ WRITE CKSUM
	root_pool                                                 ONLINE       0     0     0
	  mirror-0                                                ONLINE       0     0     0
	    nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NF0R517371-part3  ONLINE       0     0     0
	    nvme-KXG60ZNV1T02_TOSHIBA_Z9NF704ZF9ZL-part3          ONLINE       0     0     0
	  mirror-1                                                ONLINE       0     0     0
	    nvme-SAMSUNG_MZVL21T0HDLU-00B07_S77WNF0XA01902-part3  ONLINE       0     0     0
	    nvme-SAMSUNG_MZVL21T0HCLR-00B00_S676NU0W623944-part3  ONLINE       0     0     0

teutat3s in 🌐 nachtigall in ~
❯ sudo zfs list root_pool
NAME        USED  AVAIL  REFER  MOUNTPOINT
root_pool   782G  1.04T   192K  none
```
