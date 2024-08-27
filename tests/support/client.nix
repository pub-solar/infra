{
  pkgs,
  lib,
  config,
  ...
}:
let
  puppeteer-socket = (pkgs.callPackage (import ./puppeteer-socket/puppeteer-socket.nix) { });
  puppeteer-run = (pkgs.callPackage (import ./puppeteer-socket/puppeteer-run.nix) { });
in
{
  imports = [ ./global.nix ];

  security.polkit.enable = true;

  environment.systemPackages = [
    puppeteer-run
    pkgs.alacritty
  ];

  services.getty.autologinUser = config.pub-solar-os.authentication.username;

  virtualisation.qemu.options = [ "-vga std" ];

  home-manager.users.${config.pub-solar-os.authentication.username} = {
    programs.bash.profileExtra = ''
      [ "$(tty)" = "/dev/tty1" ] && exec systemd-cat --identifier=sway ${pkgs.sway}/bin/sway
    '';

    wayland.windowManager.sway = {
      enable = true;
      extraSessionCommands = ''
        export WLR_RENDERER=pixman
      '';
      config = {
        modifier = "Mod4";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        startup = [
          { command = "EXECUTABLE=${pkgs.firefox}/bin/firefox ${puppeteer-socket}/bin/puppeteer-socket"; }
        ];
      };
    };
  };

  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "192.168.1.2";
      prefixLength = 32;
    }
  ];
}
