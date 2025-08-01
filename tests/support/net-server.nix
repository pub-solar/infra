{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./global.nix
  ];

  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];

  networking.interfaces.eth1.ipv4.addresses = [
    {
      address = "192.168.1.254";
      prefixLength = 32;
    }
  ];

  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [
          "192.168.1.254"
        ];
        access-control = [
          "0.0.0.0/0 allow"
        ];
        local-zone = [
          "\"pub.solar\" transparent"
        ];
        local-data = [
          "\"${config.pub-solar-os.networking.domain}. 10800 IN CNAME web-server\""
          "\"www.${config.pub-solar-os.networking.domain}. 10800 IN CNAME web-server\""
          "\"ca.${config.pub-solar-os.networking.domain}. 10800 IN CNAME net-server\""
          "\"mail.${config.pub-solar-os.networking.domain}. 10800 IN CNAME mail-server\""
          "\"auth.${config.pub-solar-os.networking.domain}. 10800 IN CNAME auth-server\""
        ];

        tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";
      };

      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "193.110.81.0#dns0.eu"
            "2a0f:fc80::#dns0.eu"
            "185.253.5.0#dns0.eu"
            "2a0f:fc81::#dns0.eu"
          ];
          forward-tls-upstream = "yes";
        }
      ];
    };
  };

  systemd.tmpfiles.rules = [ "f /tmp/step-ca-intermediate-pw 1777 root root 10d password" ];

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
