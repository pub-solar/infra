{
  config,
  pkgs,
  lib,
  flake,
  ...
}:
{
  services.journald.extraConfig = ''
    MaxRetentionSec=3day
  '';
}
