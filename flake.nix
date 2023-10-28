{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    terranix.url = "github:terranix/terranix";

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = inputs@{ self, terranix, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      imports = [
        inputs.nixos-flake.flakeModule
        # ./terraform.nix
        ./public-keys
        ./lib
      ];

      perSystem = { config, ... }: { };

      flake =
        let
          username = "barkeeper";
          system = "x86_64-linux";
        in {
          nixosConfigurations = {
            nachtigall = self.nixos-flake.lib.mkLinuxSystem system {
              imports = [
                self.nixosModules.common
                ./hosts/nachtigall
                self.pub-solar.lib.linux.unlockZFSOnBoot
                self.nixosModules.home-manager
                self.nixosModules.linux
                {
                  home-manager.users.${username} = {
                    imports = [
                      self.homeModules.common
                    ];
                    home.stateVersion = "23.05";
                  };
                }
              ];
            };
          };

          nixosModules = {
            # Common nixos/nix-darwin configuration shared between Linux and macOS.
            common = { pkgs, ... }: {
              virtualisation.docker.enable = true;
              services.openssh.enable = true;
              services.openssh.settings.PermitRootLogin = "prohibit-password";
              services.openssh.settings.PasswordAuthentication = false;
            };

            # NixOS specific configuration
            linux = { pkgs, ... }: {
              users.users.${username} = {
                name = username;
                group = username;
                extraGroups = ["wheel"];
                isNormalUser = true;
                openssh.authorizedKeys.keys = self.publicKeys.allAdmins;
              };
              users.groups.${username} = {};

              security.sudo.wheelNeedsPassword = false;
              nix.settings.trusted-users = [ "root" username ];

              # TODO: Remove when we stop locking ourselves out.
              users.users.root.openssh.authorizedKeys.keys = self.publicKeys.allAdmins;
            };
          };

          # All home-manager configurations are kept here.
          homeModules = {
            # Common home-manager configuration shared between Linux and macOS.
            common = { pkgs, ... }: {
              programs.git.enable = true;
              programs.starship.enable = true;
              programs.bash.enable = true;
              programs.neovim = {
                enable = true;
                vimAlias = true;
                viAlias = true;
                defaultEditor = true;
                # configure = {
                #   packages.myVimPackages = with pkgs.vimPlugins; {
                #     start = [vim-nix vim-surrund rainbow];
                #   };
                # };
              };
            };
          };
          deploy.nodes = self.pub-solar.lib.deploy.mkDeployNodes self.nixosConfigurations {
            nachtigall = {
              sshUser = username;
            };
          };
        };
    };
}
