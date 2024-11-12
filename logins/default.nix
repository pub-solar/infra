{ lib, ... }:
let
  admins = import ./admins.nix;
  robots = import ./robots.nix;
in
{
  flake = {
    logins = {
      admins = admins;
      wireguardDevices = lib.lists.foldl (
        wireguardDevices: adminConfig:
        wireguardDevices ++ (if adminConfig ? "wireguardDevices" then adminConfig.wireguardDevices else [ ])
      ) [ ] (lib.attrsets.attrValues admins);
      sshPubKeys = lib.lists.foldl (
        sshPubKeys: adminConfig:
        sshPubKeys
        ++ (if adminConfig ? "sshPubKeys" then lib.attrsets.attrValues adminConfig.sshPubKeys else [ ])
      ) [ ] (lib.attrsets.attrValues admins);
      robots.sshPubKeys = lib.attrsets.attrValues robots;
    };
  };
}
