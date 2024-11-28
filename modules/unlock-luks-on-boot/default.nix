{ flake, config, ... }:
{
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      # To prevent ssh clients from freaking out because a different host key is used,
      # a different port for ssh is useful (assuming the same host has also a regular sshd running)
      port = 2222;

      # Please create this manually the first time.
      hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
      authorizedKeys = flake.self.logins.sshPubKeys;
    };
    postCommands = ''
      # Automatically ask for the password on SSH login
      echo 'cryptsetup-askpass || echo "Unlock was successful; exiting SSH session" && exit 1' >> /root/.profile
    '';
  };
}
