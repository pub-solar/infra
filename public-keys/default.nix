{ lib, ... }:
{
  flake = {
    publicKeys = {
      admins = lib.attrsets.attrValues (import ./admins.nix);
      robots = lib.attrsets.attrValues (import ./robots.nix);
    };
  };
}
