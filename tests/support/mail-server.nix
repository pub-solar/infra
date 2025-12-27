{
  lib,
  config,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.simple-nixos-mailserver.nixosModule
    flake.self.nixosModules.backups
    flake.self.nixosModules.mail
    ./global.nix
  ];

  # password is password
  systemd.tmpfiles.rules = [
    "f /tmp/emailpw 1777 root root 10d $2b$11$NV75HGZzMcIwrnVUZKXtxexX9DN52HayDW4eKrD1A8O3uIPnCquQ2"
  ];

  virtualisation.memorySize = 1024;

  mailserver = {
    stateVersion = 3;
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
