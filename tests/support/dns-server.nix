{
  config,
  flake,
  lib,
  ...
}:
{
  imports = [
    flake.self.nixosModules.home-manager
    flake.self.nixosModules.core
    ./global.nix
  ];

  networking.nameservers = lib.mkForce [
    "193.110.81.0" # dns0.eu
    "2a0f:fc80::" # dns0.eu
    "185.253.5.0" # dns0.eu
    "2a0f:fc81::" # dns0.eu
  ];

  services.resolved.enable = lib.mkForce false;

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
          "\"mail.${config.pub-solar-os.networking.domain}. 10800 IN CNAME mail-server\""
          "\"ca.${config.pub-solar-os.networking.domain}. 10800 IN CNAME acme-server\""
          "\"www.${config.pub-solar-os.networking.domain}. 10800 IN CNAME auth-server\""
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
}
