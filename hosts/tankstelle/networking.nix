{ ... }:
{
  networking = {
    hostName = "tankstelle";
    enableIPv6 = true;
    defaultGateway = {
      address = "80.244.242.1";
      interface = "enp1s0";
    };
    defaultGateway6 = {
      address = "2001:4d88:1ffa:26::1";
      interface = "enp1s0";
    };
    nameservers = [
      "95.129.51.51" # hosting.de DC resolver
      "80.244.244.244" # hosting.de DC resolver
      "2620:fe::fe" # cloud9 primary DNS
      "2620:fe::9" # cloud9 secondary DNS
    ];
    interfaces."enp1s0" = {
      ipv4.addresses = [
        {
          address = "80.244.242.6";
          prefixLength = 29;
        }
      ];
      ipv6.addresses = [
        {
          address = "2001:4d88:1ffa:26::5";
          prefixLength = 64;
        }
      ];
    };
  };
}
