{ lib, ... }: let
  admins = import ./admins.nix;
  robots = import ./robots.nix;
in {
  flake = {
    logins = {
      admins = lib.lists.foldl (logins: adminConfig: logins // {
        sshPubKeys = lib.attrsets.attrValues adminConfig.sshPubKeys;
        wireguardDevices = adminConfig.wireguardDevices;
      }) {} (lib.attrsets.attrValues admins);
      robots.sshPubKeys = lib.attrsets.attrValues robots;
    };
  };
}
