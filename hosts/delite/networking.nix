{
  config,
  pkgs,
  flake,
  ...
}:
{
  services.garage.settings.rpc_public_addr = "[2a04:52c0:124:9d8c::2]:3901";

  networking.hostName = "delite";
  networking.hostId = "00000004";

  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "ens3";
    address = [
      "5.255.119.132/24"
      "2a04:52c0:124:9d8c::2/48"
    ];
    gateway = [
      "5.255.119.1"
      "2a04:52c0:124::1"
    ];
  };
}
