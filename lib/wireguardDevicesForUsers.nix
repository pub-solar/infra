{ lib }:
users:
lib.lists.foldl (
  wireguardDevices: userConfig:
  wireguardDevices ++ (if userConfig ? "wireguardDevices" then userConfig.wireguardDevices else [ ])
) [ ] (lib.attrsets.attrValues users)
