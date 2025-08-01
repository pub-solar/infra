{
  pkgs,
  lib,
  config,
  flake,
  ...
}:
{
  imports = [
    flake.self.nixosModules.home-manager
    flake.self.nixosModules.core
  ];

  virtualisation.diskImage = null;
  virtualisation.cores = lib.mkDefault 4;
  virtualisation.memorySize = lib.mkDefault 4096;

  pub-solar-os.adminEmail = "admin@test.pub.solar";
  pub-solar-os.authentication.users.test-user = { };
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
    DNSOverTLS=no
  '';

  environment.systemPackages = [
    pkgs.dig
  ];

  # set some improved postgresql settings
  services.postgresql.settings = {
    # avoid checkpoints being created during tests
    checkpoint_timeout = "2h";

    # disable autovacuum
    autovacuum = "off";

    # disable fsync
    fsync = "off";

    # set work_mem to 20MB
    work_mem = lib.mkForce "20480kB";

    # set random_page_cost to 1
    random_page_cost = lib.mkForce 1;
  };
}
