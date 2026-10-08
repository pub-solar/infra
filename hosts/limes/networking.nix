{ ... }:
{
  services.garage.settings.rpc_public_addr = "[2001:4d88:1ffa:26::15]:3901";

  networking.hostName = "limes";
  networking.hostId = "00000105";

  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.wait-online.anyInterface = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";
    address = [
      "2001:4d88:1ffa:26::15/64"
    ];
    gateway = [
      "2001:4d88:1ffa:26::1"
    ];
  };
}
