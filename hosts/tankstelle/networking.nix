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
    interfaces."enp1s0" = {
      useDHCP = false;
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
