{
  inputs = {
    # Track channels with commits tested and built by hydra
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    mastodon-fork.url = "github:teutat3s/nixpkgs/mastodon-4.2.1";

    nixpkgs-2205.url = "github:nixos/nixpkgs/nixos-22.05";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "nix-darwin";
    agenix.inputs.home-manager.follows = "home-manager";

    keycloak-theme-pub-solar.url = "git+https://git.pub.solar/pub-solar/keycloak-theme?ref=main";
    keycloak-theme-pub-solar.inputs.nixpkgs.follows = "nixpkgs";

    triton-vmtools.url = "git+https://git.pub.solar/pub-solar/infra-vintage?ref=main&dir=vmtools";
    triton-vmtools.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        inputs.nixos-flake.flakeModule
        ./public-keys
        ./lib
        ./overlays
        ./modules
        ./hosts
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
            inputs.nixpkgs-2205.legacyPackages.${system}.terraform
          ];
        };
      };

      flake =
        let
          username = "barkeeper";
        in {
          inherit username;

          checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

          deploy.nodes = self.lib.deploy.mkDeployNodes self.nixosConfigurations {
            nachtigall = {
              # hostname is set in hosts/nachtigall/networking.nix
              sshUser = username;
            };
            flora-6 = {
              hostname = "flora-6.pub.solar";
              sshUser = username;
              # Example
              #sshOpts = [ "-p" "19999" ];
            };
          };
        };
    };
}
