{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
    autoPrune.enable = true;
    extraOptions = ''
      --data-root /var/lib/docker
    '';
    storageDriver = "zfs";
  };

  networking.firewall.trustedInterfaces = [ "docker0" ];

  # Load kernel modules early for docker, otherwise it fails to start because we
  # disable dynamically loading kernel modules after boot with
  # momo-cloud.boot.enableKernelHardening and sysctl kernel.modules_disabled=1
  boot.kernelModules = [
    "ip_set"
    "ip_set_hash_net"
    "ip6_tables"
    "ip6table_filter"
    "ip6table_nat"
    "ip6t_REJECT"
    "ipt_REJECT"
    "iptable_filter"
    "iptable_nat"
    "nf_conntrack_netlink"
    "nft_compat"
    "nft_nat"
    "nft_reject_inet"
    "nft_reject_ipv4"
    "nft_reject_ipv6"
    "overlay"
    "xt_addrtype"
    "xt_MASQUERADE"
    "xt_multiport"
    "xt_set"
    "xt_tcpudp"
  ];
}
