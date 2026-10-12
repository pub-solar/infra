{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0";
        content = {
          type = "gpt";
          partitions = {
            bios = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            boot = {
              size = "1G";
              type = "8300";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [ ];
                content = {
                  type = "lvm_pv";
                  vg = "vg0";
                };
              };
            };
          };
        };
      };
      data = {
        type = "disk";
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptmeta";
                extraOpenArgs = [ ];
                content = {
                  type = "filesystem";
                  format = "btrfs";
                  mountpoint = "/var/lib/garage/meta";
                  mountOptions = [ "defaults" ];
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "40G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
                "discard"
                "x-systemd.device-timeout=infinity"
              ];
            };
          };
          swap = {
            size = "8G";
            content = {
              type = "swap";
            };
          };
          data = {
            size = "800G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/var/lib/garage/data";
              mountOptions = [ "defaults" ];
            };
          };
        };
      };
    };
  };
}
