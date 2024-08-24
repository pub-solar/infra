{
  config,
  pkgs,
  flake,
  ...
}:
{
  services.garage.settings.rpc_public_addr = "[2a01:239:35d:f500::1]:3901";

  networking.hostName = "trinkgenossin";
  networking.hostId = "00000003";

  networking.enableIPv6 = true;
  networking.useDHCP = true;
}
