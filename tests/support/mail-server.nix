{
  config,
  flake,
  ...
}: {
  imports = [
    flake.self.nixosModules.home-manager
    flake.self.nixosModules.core
    flake.self.nixosModules.mail
    flake.inputs.simple-nixos-mailserver.nixosModule
    ./global.nix
  ];

  # password is password
  systemd.tmpfiles.rules = [ "f /tmp/emailpw 1777 root root 10d $2b$11$NV75HGZzMcIwrnVUZKXtxexX9DN52HayDW4eKrD1A8O3uIPnCquQ2" ];

  mailserver = {
    loginAccounts = {
      "admins@${config.pub-solar-os.networking.domain}" = {
        hashedPasswordFile = "/tmp/emailpw";
      };
      "hakkonaut@${config.pub-solar-os.networking.domain}" = {
        hashedPasswordFile = "/tmp/emailpw";
      };
      "test-user@${config.pub-solar-os.networking.domain}" = {
        quota = "1G";
        hashedPasswordFile = "/tmp/emailpw";
      };
    };
  };
}
