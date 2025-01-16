{
  flake,
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
  imports = [
    flake.self.nixosModules.home-manager
    flake.self.nixosModules.core
    ./global.nix
  ];

  security.polkit.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "b12f";

  environment.systemPackages = [
    puppeteer-run
    pkgs.alacritty
  ];

  services.getty.autologinUser = "b12f";

  virtualisation.qemu.options = [ "-vga std" ];

  home-manager.users.b12f = {
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

    accounts.email.accounts."test-user@${config.pub-solar-os.networking.domain}" = {
      primary = true;
      address = "test-user@${config.pub-solar-os.networking.domain}";
      userName = "test-user@${config.pub-solar-os.networking.domain}";
      passwordCommand = "echo password";
      realName = "Test User";
      imap = {
        host = "mail.${config.pub-solar-os.networking.domain}";
        port = 993;
      };
      smtp = {
        host = "mail.${config.pub-solar-os.networking.domain}";
        port = 587;
        tls.useStartTls = true;
      };
      getmail.enable = true;
      getmail.mailboxes = [ "ALL" ];
      msmtp.enable = true;
    };
  };
}
