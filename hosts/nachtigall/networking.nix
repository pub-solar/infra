{ config, pkgs, ... }:
{

  networking.hostName = "nachtigall";
  networking.domain = "pub.solar";
  networking.hostId = "00000001";

  # Network (Hetzner uses static IP assignments, and we don't use DHCP here)
  networking.useDHCP = false;
  networking.interfaces."enp35s0".ipv4.addresses = [
    {
      address = "138.201.80.102";
      prefixLength = 26;
    }
  ];
  networking.interfaces."enp35s0".ipv6.addresses = [
    {
      address = "2a01:4f8:172:1c25::1";
      prefixLength = 64;
    }
  ];
  networking.defaultGateway = "138.201.80.65";
  networking.defaultGateway6 = { address = "fe80::1"; interface = "enp35s0"; };

  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=193.110.81.0#dns0.eu 185.253.5.0#dns0.eu 2a0f:fc80::#dns0.eu 2a0f:fc81::#dns0.eu 9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
      FallbackDNS=5.1.66.255#dot.ffmuc.net 185.150.99.255#dot.ffmuc.net 2001:678:e68:f000::#dot.ffmuc.net 2001:678:ed0:f000::#dot.ffmuc.net
      Domains=~.
      DNSOverTLS=yes
    '';
  };
}
