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

  # Allow dovecot to access /tmp/emailpw
  systemd.services.dovecot = {
    serviceConfig = {
      PrivateTmp = lib.mkForce false;
    };
  };

  # rspamd needs internet connection to work, which is not available in NixOS
  # test so we disable it and remove references to rspamd from postfix
  services.rspamd = {
    enable = lib.mkForce false;
  };

  services.postfix.settings.main.smtpd_milters = lib.mkForce [ ];

  systemd.services.postfix = {
    after = lib.mkForce [
      "postfix-tlspol.service"
      "network.target"
      "postfix-setup.service"
    ];
    requires = lib.mkForce [
      "postfix-setup.service"
      "dovecot.service"
    ];
  };

  mailserver = {
    stateVersion = 3;
    dkimSigning = false;
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
