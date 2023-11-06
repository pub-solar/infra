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

      core = {
        imports = [
          nix
          networking
          terminal-tooling
          users
        ];

        home-manager.users.${self.username} = {
          home.stateVersion = "23.05";
        };
      };
    };
  };
}
