{ lib, ... }:
let
  admins = import ./admins.nix;
  robots = import ./robots.nix;
in
{
  flake = {
    logins = {
      admins = admins;
      robots.sshPubKeys = lib.attrsets.attrValues robots;
    };
  };
}
