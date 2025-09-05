{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  # has issues with resolving DNS after a while, needs investigation
  services.resolved.enable = lib.mkForce false;

  # resolvconf handles DNS settings
  # Use local knot resolver provided by simple-nixos-mailserver, they enable
  # this option for us
  # networking.resolvconf.useLocalResolver = true;

  networking.hostName = "metronom";
  networking.extraHosts = ''
    127.0.0.2 mail.pub.solar mail
    ::1 mail.pub.solar mail
  '';
  networking.hostId = "00000002";

  networking.useNetworkd = true;
  # https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud#Network_configuration
  systemd.network.enable = true;
  systemd.network.networks."30-wan" = {
    matchConfig.Name = "enp1s0";
    networkConfig.DHCP = "ipv4";
    address = [
      "2a01:4f8:c2c:7082::1/64"
    ];
    routes = [
      { Gateway = "fe80::1"; }
    ];
  };
}
