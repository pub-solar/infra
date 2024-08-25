{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./global.nix ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = config.pub-solar-os.authentication.username;

  systemd.user.services = {
    "org.gnome.Shell@wayland" = {
      serviceConfig = {
        ExecStart = [
          # Clear the list before overriding it.
          ""
          # Eval API is now internal so Shell needs to run in unsafe mode.
          "${pkgs.gnome.gnome-shell}/bin/gnome-shell --unsafe-mode"
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
