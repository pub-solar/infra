  { self, ... }:
  {
    flake = {
      nixosConfigurations = {
        nachtigall = self.nixos-flake.lib.mkLinuxSystem {
          imports = [
            self.inputs.agenix.nixosModules.default
            self.nixosModules.home-manager
            ./nachtigall
            self.nixosModules.overlays
            self.nixosModules.unlock-zfs-on-boot
            self.nixosModules.core
            self.nixosModules.docker
          ];
        };
      };
    };
  }
