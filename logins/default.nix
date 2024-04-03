{ lib, ... }: let
  admins = import ./admins.nix;
  robots = import ./robots.nix;
in {
  flake = {
    logins = {
      admins = lib.lists.foldl (logins: adminConfig: logins // {
        sshPubKeys = lib.attrsets.attrValues adminConfig.sshPubKeys;
        wireguardDevices = if adminConfig ? "wireguardDevices" then adminConfig.wireguardDevices else [];
      }) {} (lib.attrsets.attrValues admins);
      robots.sshPubKeys = lib.attrsets.attrValues robots;
    };
  };
}
