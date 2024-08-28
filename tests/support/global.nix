{
  pkgs,
  lib,
  config,
  ...
}:
{
  pub-solar-os.networking.domain = "test.pub.solar";

  security.acme.defaults.server = "https://ca.${config.pub-solar-os.networking.domain}/acme/acme/directory";

  security.pki.certificates = [ (builtins.readFile ./step/certs/root_ca.crt) ];

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = lib.mkForce "yes";
      PermitEmptyPasswords = lib.mkForce "yes";
      PasswordAuthentication = lib.mkForce true;
    };
  };

  security.pam.services.sshd.allowNullPassword = true;

  services.resolved.extraConfig = lib.mkForce ''
    DNS=192.168.1.254
    Domains=~.
  '';

  environment.systemPackages = [
    pkgs.dig
  ];
}

