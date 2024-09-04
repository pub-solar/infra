{
  config,
  pkgs,
  flake,
  ...
}:
{
  services.garage.settings.rpc_public_addr = "[2a03:4000:43:24e::1]:3901";

  networking.hostName = "blue-shell";
  networking.hostId = "00000005";

  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "ens3";
    address = [
      "194.13.83.205/22"
      "2a03:4000:43:24e::1/64"
    ];
    gateway = [
      "194.13.80.1"
      "fe80::1"
    ];
  };
}
