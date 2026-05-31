{
  coreutils,
  gnugrep,
  procps,
  writeShellApplication,
}:
# writeShellApplication uses:
# set -o errexit
# set -o nounset
# set -o pipefail
writeShellApplication {
  name = "disable-loading-kernel-modules";
  text = ''
    # check if post-boot kernel hardening measures were disabled by kernel boot flag
    if ${gnugrep}/bin/grep "kernel_hardening=off" /proc/cmdline > /dev/null; then
      ${coreutils}/bin/echo "kernel hardening disabled by boot flag"
      exit 0
    fi

    ${coreutils}/bin/echo "freeze loaded kernel modules"
    ${procps}/bin/sysctl -w kernel.modules_disabled=1
  '';
}
