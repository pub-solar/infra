{ ... }:
{
  networking = {
    hostName = "tankstelle";
    enableIPv6 = true;
    defaultGateway6 = {
      address = "2001:4d88:1ffa:26::1";
      interface = "enp1s0";
    };
    nameservers = [
      "2620:fe::fe"
      "2620:fe::9"
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
