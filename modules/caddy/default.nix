{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  services.caddy = {
    enable = lib.mkForce true;
    group = config.pub-solar-os.authentication.robot.username;
    email = config.pub-solar-os.adminEmail;
    enableReload = true;
    globalConfig = lib.mkForce ''
      grace_period 60s
    '';
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
