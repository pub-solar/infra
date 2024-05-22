{
  config,
  pkgs,
  flake,
  ...
}:
{

  networking.hostName = "metronom";
  networking.domain = "pub.solar";
  networking.hostId = "00000002";

  networking.enableIPv6 = true;
  networking.useDHCP = false;
  networking.interfaces."enp1s0".useDHCP = true;

  # TODO: ssh via wireguard only
  services.openssh.openFirewall = true;
}
