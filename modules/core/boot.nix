{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.pub-solar-os.boot =
    let
      inherit (lib) mkOption types;
    in
    {
      enableKernelHardening = mkOption {
        description = "Whether to disable loading kernel modules after boot";
        type = types.bool;
        default = true;
      };
    };

  config = {
    boot.loader.grub.configurationLimit = lib.mkDefault 15;
    boot.loader.systemd-boot.configurationLimit = lib.mkDefault 15;

    # Prevent kernel vulnerabilities like CVE-2026-43284 CVE-2026-43500 pintheft
    systemd.services."disable-loading-kernel-modules" =
      lib.mkIf config.pub-solar-os.boot.enableKernelHardening
        {
          description = "Disable loading kernel modules to reduce kernel attack surface";
          after = [ "systemd-logind.service" ];
          before = [
            "getty.target"
            "network.target"
          ];
          serviceConfig = {
            ExecStart = "${lib.getExe pkgs.disable-loading-kernel-modules}";
            Type = "oneshot";
          };
          wantedBy = [ "multi-user.target" ];
        };
  };
}
