{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.pub-solar-os.networking =
    let
      inherit (lib) mkOption types;
    in
    {
      domain = mkOption {
        description = "domain on which all services should run. This defaults to pub.solar";
        type = types.str;
        default = "pub.solar";
      };

      defaultInterface = mkOption {
        description = "Network interface which should be used as the default internet-connected one";
        type = types.nullOr types.str;
      };
    };

  config = {

    # Don't expose SSH via public interfaces
    networking.firewall.interfaces.wg-ssh.allowedTCPPorts = [ 22 ];

    # Load kernel modules early for docker, nix remote build otherwise it fails to start because we
    # disable dynamically loading kernel modules after boot with
    # pub-solar-os.boot.enableKernelHardening and sysctl kernel.modules_disabled=1
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
      "nft_chain_nat"
      "nft_compat"
      "nft_log"
      "nft_nat"
      "nft_reject_inet"
      "nft_reject_ipv4"
      "nft_reject_ipv6"
      "overlay"
      "tun"
      "xt_addrtype"
      "xt_MASQUERADE"
      "xt_multiport"
      "xt_set"
      "xt_tcpudp"
    ];

    # Setting this value breaks Matrix -> NextPush integration because
    # matrix-synapse doesn't like it if nachtigall.pub.solar resolves to localhost.
    #networking.domain = config.pub-solar-os.networking.domain;

    networking.hosts = {
      "10.7.6.1" = [ "nachtigall.wg.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.3" = [ "metronom.wg.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.4" = [ "tankstelle.wg.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.5" = [ "trinkgenossin.wg.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.6" = [ "delite.wg.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.7" = [ "blue-shell.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:1::" = [ "nachtigall.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:3::" = [ "metronom.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:4::" = [ "tankstelle.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:5::" = [ "trinkgenossin.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:6::" = [ "delite.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:7::" = [ "blue-shell.wg.${config.pub-solar-os.networking.domain}" ];
    };

    services.openssh = {
      enable = true;
      openFirewall = lib.mkDefault false;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    # These nameservers land in resolved.conf as 'DNS=<list>'
    networking.nameservers = lib.mkDefault [
      "86.54.11.100#unfiltered.joindns4.eu"
      "86.54.11.200#unfiltered.joindns4.eu"
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
      "2a13:1001::86:54:11:100#unfiltered.joindns4.eu"
      "2a13:1001::86:54:11:200#unfiltered.joindns4.eu"
      "2620:fe::fe#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
    ];
    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNSOverTLS = lib.mkDefault "true";
        # default value in nixos module
        DNSSEC = lib.mkDefault "false";
        Domains = lib.mkDefault [
          "~."
        ];
        FallbackDNS = lib.mkDefault [
          "5.1.66.255#dot.ffmuc.net"
          "185.150.99.255#dot.ffmuc.net"
          "2001:678:e68:f000::#dot.ffmuc.net"
          "2001:678:ed0:f000::#dot.ffmuc.net"
        ];
      };
    };
  };
}
