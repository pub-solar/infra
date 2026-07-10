{ lib, config, ... }:
{
  # From https://wiki.nixos.org/wiki/ZFS#Remote_unlock
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      # To prevent ssh clients from freaking out because a different host key is used,
      # a different port for ssh is useful (assuming the same host has also a regular sshd running)
      port = 2222;

      # Please create this manually the first time.
      hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
      authorizedKeys = lib.lists.foldl (
        sshPubKeys: userConfig:
        sshPubKeys
        ++ (
          if userConfig ? "sshPubKeys" then
            map (x: ''command="systemctl default" '' + x) (lib.attrsets.attrValues userConfig.sshPubKeys)
          else
            [ ]
        )
      ) [ ] (lib.attrsets.attrValues config.pub-solar-os.authentication.users);
    };
  };
}
