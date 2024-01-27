/*
 * The contents of this file are adapted from digga
 * https://github.com/divnix/digga
 *
 * Licensed under the MIT license
 */

{ lib, inputs }:
let
  # https://github.com/serokell/deploy-rs#overall-usage
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs { inherit system; };
  deployPkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      inputs.deploy-rs.overlay
      (self: super: { deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; })
    ];
  };
  getFqdn = c:
    let
      net = c.config.networking;
      fqdn =
        if (net ? domain) && (net.domain != null)
        then "${net.hostName}.${net.domain}"
        else net.hostName;
    in
    fqdn;
in
{
  mkDeployNodes = systemConfigurations: extraConfig:
    /*
     *
       Synopsis: mkNodes _systemConfigurations_ _extraConfig_

       Generate the `nodes` attribute expected by deploy-rs
       where _systemConfigurations_ are `nodes`.

       _systemConfigurations_ should take the form of a flake's
       _nixosConfigurations_. Note that deploy-rs does not currently support
       deploying to darwin hosts.

       _extraConfig_, if specified, will be merged into each of the
       nodes' configurations.

       Example _systemConfigurations_ input:

       ```
       {
       hostname-1 = {
       fastConnection = true;
       sshOpts = [ "-p" "25" ];
       };
       hostname-2 = {
       sshOpts = [ "-p" "19999" ];
       sshUser = "root";
       };
       }
       ```
     *
     */
    lib.recursiveUpdate
      (lib.mapAttrs
        (
          _: c: {
            hostname = getFqdn c;
            profiles.system = {
              user = "root";
              path = deployPkgs.deploy-rs.lib.activate.nixos c;
            };
          }
        )
        systemConfigurations)
      extraConfig;
}
