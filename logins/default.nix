{ lib, ... }: let
  admins = import ./admins.nix;
  robots = import ./robots.nix;
in {
  flake = {
    logins = {
      admins = lib.lists.foldl (logins: adminConfig: {
        sshPubKeys = logins.sshPubKeys ++ (lib.attrsets.attrValues adminConfig.sshPubKeys);
        wireguardDevices = logins.wireguardDevices ++ (if adminConfig ? "wireguardDevices" then adminConfig.wireguardDevices else []);
      }) { sshPubKeys = []; wireguardDevices = []; } (lib.attrsets.attrValues admins);
      robots.sshPubKeys = lib.attrsets.attrValues robots;
    };
  };
}
