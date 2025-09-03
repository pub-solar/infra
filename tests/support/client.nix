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

  startup = pkgs.writeShellScript "startup" ''
    set -e
    set -x

    EXECUTABLE=${pkgs.chromium}/bin/chromium ${puppeteer-socket}/bin/puppeteer-socket
  '';
in
{
  imports = [
    flake.self.nixosModules.home-manager
    flake.self.nixosModules.core
    ./global.nix
  ];

  security.polkit.enable = true;

  environment.systemPackages = [
    puppeteer-run
    pkgs.alacritty
    pkgs.mailutils
    pkgs.oath-toolkit
  ];

  services.getty.autologinUser = "test-user";

  virtualisation.cores = 8;
  virtualisation.memorySize = 8192;
  # virtualisation.qemu.options = [ "-vga std" ];

  home-manager.users.test-user = {
    programs.bash.profileExtra = ''
      [ "$(tty)" = "/dev/tty1" ] && exec systemd-cat --identifier=sway ${pkgs.sway}/bin/sway
    '';

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      extraSessionCommands = ''
        export WLR_RENDERER=pixman
      '';
      config = {
        modifier = "Mod4";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        startup = [
          { command = "${startup}"; }
        ];
      };
    };

    programs.offlineimap.enable = true;

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
      offlineimap.enable = true;
    };
  };
}
