{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./global.nix
  ];

  programs.sway = {
    enable = true;
  };

  programs.bash.shellInit = ''
    exec sway
  '';

  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "192.168.1.2";
      prefixLength = 32;
    }
  ];
}
