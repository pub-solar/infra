{
  inputs = {
    # Track channels with commits tested and built by hydra
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    fork.url = "github:teutat3s/nixpkgs/init-matrix-authentication-service-module-0.13.0";
    codeberg-pages.url = "github:nixos/nixpkgs/refs/pull/395725/head";
    # Need to use the backported module because of https://github.com/NixOS/nixpkgs/pull/403645
    mastodon-backport.url = "github:teutat3s/nixpkgs/mastodon-4.4";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "nix-darwin";
    agenix.inputs.home-manager.follows = "home-manager";

    keycloak-theme-pub-solar.url = "git+https://git.pub.solar/pub-solar/keycloak-theme?ref=main";
    keycloak-theme-pub-solar.inputs.nixpkgs.follows = "nixpkgs";

    keycloak-event-listener.url = "git+https://git.pub.solar/pub-solar/keycloak-event-listener?ref=main";
    keycloak-event-listener.inputs.nixpkgs.follows = "unstable";

    element-themes.url = "github:aaronraimist/element-themes/master";
    element-themes.flake = false;

    maunium-stickerpicker.url = "github:maunium/stickerpicker?ref=master";
    maunium-stickerpicker.flake = false;

    element-stickers.url = "git+https://git.pub.solar/pub-solar/maunium-stickerpicker-nix?ref=main";
    element-stickers.inputs.maunium-stickerpicker.follows = "maunium-stickerpicker";
    element-stickers.inputs.nixpkgs.follows = "nixpkgs";

    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.05";
    simple-nixos-mailserver.inputs.nixpkgs-25_05.follows = "nixpkgs";
    simple-nixos-mailserver.inputs.nixpkgs.follows = "unstable";
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        ./logins
        ./lib
        ./overlays
        ./hosts
      ];

      perSystem =
        args@{
          system,
          pkgs,
          config,
          lib,
          ...
        }:
        {
          _module.args = {
            inherit inputs;
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ inputs.agenix.overlays.default ];
            };
            unstable = import inputs.unstable { inherit system; };
          };

          checks =
            let
              machinesPerSystem = {
                x86_64-linux = [
                  "blue-shell"
                  "delite"
                  "nachtigall"
                  "tankstelle"
                  "trinkgenossin"
                  "underground"
                ];
              };
              nixosMachines = inputs.nixpkgs.lib.mapAttrs' (n: inputs.nixpkgs.lib.nameValuePair "nixos-${n}") (
                inputs.nixpkgs.lib.genAttrs (machinesPerSystem.${system} or [ ]) (
                  name: self.nixosConfigurations.${name}.config.system.build.toplevel
                )
              );
            in
            import ./tests {
              inherit
                config
                inputs
                lib
                pkgs
                self
                system
                ;
            }
            // nixosMachines;

          packages.nginx-dhparam-ffdhe2048 = pkgs.callPackage ./overlays/pkgs/nginx-dhparam-ffdhe2048 { };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              deploy-rs
              nix-fast-build
              agenix
              age-plugin-yubikey
              cachix
              editorconfig-checker
              nix-diff
              nodePackages.prettier
              nvfetcher
              shellcheck
              shfmt
              treefmt
              nixos-generators
              opentofu
              terraform-backend-git
              terraform-ls
              jq

              # For the tests puppeteer-socket pkg
              nodejs
              nodePackages.typescript
              nodePackages.typescript-language-server
            ];
          };

          devShells.ci = pkgs.mkShell { buildInputs = with pkgs; [ nodejs ]; };
        };

      flake = {
        nixosModules = builtins.listToAttrs (
          map (x: {
            name = x;
            value = import (./modules + "/${x}");
          }) (builtins.attrNames (builtins.readDir ./modules))
        );

        checks = builtins.mapAttrs (
          system: deployLib: deployLib.deployChecks self.deploy
        ) inputs.deploy-rs.lib;

        formatter."x86_64-linux" = inputs.nixpkgs.legacyPackages."x86_64-linux".nixfmt-rfc-style;

        deploy.nodes = self.lib.deploy.mkDeployNodes self.nixosConfigurations {
          nachtigall = {
            hostname = "nachtigall.wg.pub.solar";
          };
          metronom = {
            hostname = "metronom.wg.pub.solar";
          };
          tankstelle = {
            hostname = "tankstelle.wg.pub.solar";
          };
          underground = {
            hostname = "80.244.242.3";
          };
          trinkgenossin = {
            hostname = "trinkgenossin.wg.pub.solar";
          };
          delite = {
            hostname = "delite.wg.pub.solar";
          };
          blue-shell = {
            hostname = "blue-shell.wg.pub.solar";
          };
        };
      };
    };
}
