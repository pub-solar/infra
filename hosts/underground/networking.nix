{
  config,
  pkgs,
  flake,
  ...
}:
{

  networking.hostName = "underground";

  networking = {
    defaultGateway = {
      address = "80.244.242.1";
      interface = "enp1s0";
    };
    nameservers = ["95.129.51.51" "80.244.244.244"];
    interfaces.enp1s0 = {
      useDHCP = false;
      ipv4.addresses = [
        { address = "80.244.242.3"; prefixLength = 29; }
      ];
    };
  };
}
