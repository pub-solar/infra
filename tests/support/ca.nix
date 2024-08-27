{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./global.nix ];

  systemd.tmpfiles.rules = [ "f /tmp/step-ca-intermediate-pw 1777 root root 10d password" ];

  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "192.168.1.1";
      prefixLength = 32;
    }
  ];

  services.step-ca =
    let
      certificates = pkgs.stdenv.mkDerivation {
        name = "certificates";
        src = ./step;
        installPhase = ''
          mkdir -p $out;
          cp -r certs $out/
          cp -r secrets $out/
        '';
      };
    in
    {
      enable = true;
      openFirewall = true;
      intermediatePasswordFile = "/tmp/step-ca-intermediate-pw";
      port = 443;
      address = "0.0.0.0";
      settings = (builtins.fromJSON (builtins.readFile ./step/config/ca.json)) // {
        root = "${certificates}/certs/root_ca.crt";
        crt = "${certificates}/certs/intermediate_ca.crt";
        key = "${certificates}/secrets/intermediate_ca_key";
        db = {
          type = "badgerv2";
          dataSource = "/var/lib/step-ca/db";
        };
      };
    };
}
