{ pkgs, config, flake, lib, ... }: {
  imports = [
    ./nix.nix
    ./networking.nix
    ./terminal-tooling.nix
    ./users.nix
  ];

  options.pub-solar-os = with lib; {
    adminEmail = mkOption {
      description = "Email address to use for administrative stuff like ACME";
      type = types.str;
      default = "admins@pub.solar";
    };
  };

  config = {
    environment = {
      # Just a couple of global packages to make our lives easier
      systemPackages = with pkgs; [ git vim wget ];
    };

    # Select internationalization properties
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    time.timeZone = "Etc/UTC";

    home-manager.users.${config.pub-solar-os.authentication.username} = {
      home.stateVersion = "23.05";
    };
  };
}