{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vdb";
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
                # if you want to use the key for interactive login be sure there is no trailing newline
                # for example use `echo -n "password" > /tmp/secret.key`
                passwordFile = "/tmp/luks-password";
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
        device = "/dev/vdc";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptdata";
                extraOpenArgs = [ ];
                # if you want to use the key for interactive login be sure there is no trailing newline
                # for example use `echo -n "password" > /tmp/secret.key`
                passwordFile = "/tmp/luks-password";
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
    };
    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
            };
          };
          swap = {
            size = "16G";
            content = {
              type = "swap";
            };
          };
          metadata = {
            size = "50G";
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
}
