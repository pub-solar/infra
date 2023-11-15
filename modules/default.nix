{ self, ... }:
{
  flake = {
    nixosModules = rec {
      nix = import ./nix.nix;
      networking = import ./networking.nix;
      unlock-zfs-on-boot = import ./unlock-zfs-on-boot.nix;
      docker = import ./docker.nix;
      terminal-tooling = import ./terminal-tooling.nix;
      users = import ./users.nix;

      core = { pkgs, ... }: {
        imports = [
          nix
          networking
          terminal-tooling
          users
        ];

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

        home-manager.users.${self.username} = {
          home.stateVersion = "23.05";
        };
      };
    };
  };
}
