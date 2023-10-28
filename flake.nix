{
  inputs = {
    # Track channels with commits tested and built by hydra
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "nix-darwin";
    agenix.inputs.home-manager.follows = "home-manager";
  };

  outputs = inputs@{ self, terranix, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        inputs.nixos-flake.flakeModule
        # ./terraform.nix
        ./public-keys
        ./lib
      ];

      perSystem = { system, pkgs, config, ... }: {
        _module.args = {
          inherit inputs;
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.agenix.overlays.default
            ];
          };
          unstable = import inputs.unstable { inherit system; };
          master = import inputs.master { inherit system; };
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            deploy-rs
            nixpkgs-fmt
            agenix
            cachix
            editorconfig-checker
            nix
            nodePackages.prettier
            nvfetcher
            shellcheck
            shfmt
            treefmt
            nixos-generators
          ];
        };
      };

      flake =
        let
          username = "barkeeper";
          system = "x86_64-linux";
        in {
          nixosConfigurations = {
            nachtigall = self.nixos-flake.lib.mkLinuxSystem {
              imports = [
                self.nixosModules.common
                ./hosts/nachtigall
                self.pub-solar.lib.linux.unlockZFSOnBoot
                self.nixosModules.home-manager
                self.nixosModules.linux
                inputs.agenix.nixosModules.default
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
