{ lib, ... }:

{
  boot.loader.grub.configurationLimit = lib.mkDefault 15;
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 15;
}
