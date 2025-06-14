{ ... }:
{
  services.resolved.fallbackDns = [
    "2001:678:e68:f000::#dot.ffmuc.net"
    "2001:678:ed0:f000::#dot.ffmuc.net"
  ];
  networking = {
    hostName = "tankstelle";
    useDHCP = false;
    enableIPv6 = true;
    defaultGateway6 = {
      address = "2001:4d88:1ffa:26::1";
      interface = "enp1s0";
    };
    nameservers = [
      "2a0f:fc80::#dns0.eu"
      "2a0f:fc81::#dns0.eu"
      "2620:fe::fe#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
    ];
    interfaces."enp1s0" = {
      ipv6.addresses = [
        {
          address = "2001:4d88:1ffa:26::5";
          prefixLength = 64;
        }
      ];
    };
  };
}
