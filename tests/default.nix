args@{
  self,
  lib,
  system,
  pkgs,
  inputs,
  ...
}:
let
  nixos-lib = import (inputs.nixpkgs + "/nixos/lib") { };

  loadTestFiles =
    with lib;
    dir:
    mapAttrs' (
      name: _:
      let
        test = ((import (dir + "/${name}")) args);
      in
      {
        name = "test-" + (lib.strings.removeSuffix ".nix" name);
        value = nixos-lib.runTest test;
      }
    ) (filterAttrs (name: _: (hasSuffix ".nix" name) && name != "default.nix") (builtins.readDir dir));
in
loadTestFiles ./.
