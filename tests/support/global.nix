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

  virtualisation.forwardPorts =
    let
      address = (builtins.elemAt config.networking.interfaces.eth0.ipv4.addresses 0).address;
      lastAddressPart = builtins.elemAt (lib.strings.splitString "." address) 3;
    in
    [
      {
        from = "host";
        host.port = 2000 + (lib.strings.toInt lastAddressPart);
        guest.port = 22;
      }
    ];

  networking.interfaces.eth0.useDHCP = false;

  networking.hosts = {
    "192.168.1.1" = [ "ca.${config.pub-solar-os.networking.domain}" ];
    "192.168.1.2" = [ "client.${config.pub-solar-os.networking.domain}" ];
    "192.168.1.3" = [
      "${config.pub-solar-os.networking.domain}"
      "www.${config.pub-solar-os.networking.domain}"
      "auth.${config.pub-solar-os.networking.domain}"
    ];
  };

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
