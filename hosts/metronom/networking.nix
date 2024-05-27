{
  config,
  pkgs,
  flake,
  ...
}:
{

  networking.hostName = "metronom";
  networking.extraHosts = ''
    127.0.0.2 mail.pub.solar mail
    ::1 mail.pub.solar mail
  '';
  networking.domain = "pub.solar";
  networking.hostId = "00000002";

  networking.enableIPv6 = true;
  networking.useDHCP = false;
  networking.interfaces."enp1s0".useDHCP = true;

  # TODO: ssh via wireguard only
  services.openssh.openFirewall = true;
}
