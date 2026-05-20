{ lib, pkgs, ... }:

{
  boot.loader.grub.configurationLimit = lib.mkDefault 15;
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 15;

  # Prevent CVE-2026-43284 CVE-2026-43500
  boot.extraModprobeConfig = ''
    install esp4 ${pkgs.coreutils}/bin/false
    install esp6 ${pkgs.coreutils}/bin/false
    install rxrpc ${pkgs.coreutils}/bin/false
    install rds ${pkgs.coreutils}/bin/false
    install rds_tcp ${pkgs.coreutils}/bin/false
  '';
  boot.blacklistedKernelModules = [
    "esp4"
    "esp6"
    "rxrpc"
    "rds"
    "rds_tcp"
  ];
}
