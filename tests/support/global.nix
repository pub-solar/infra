{
  pkgs,
  lib,
  config,
  ...
}: {
  pub-solar-os.networking.domain = "test.pub.solar";

  security.acme.defaults.server = "https://ca.${config.pub-solar-os.networking.domain}/acme/acme/directory";

  security.pki.certificates = [
    (builtins.readFile ./step/certs/root_ca.crt)
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
}
