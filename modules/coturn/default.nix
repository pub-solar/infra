{ flake, config, lib, ... }:
{
  age.secrets."coturn-static-auth-secret" = {
    file = "${flake.self}/secrets/coturn-static-auth-secret.age";
    mode = "400";
    owner = "turnserver";
  };

  services.coturn = rec {
    enable = true;
    no-cli = true;
    no-tcp-relay = true;
    min-port = 49000;
    max-port = 50000;
    use-auth-secret = true;
    static-auth-secret-file = "/run/agenix/coturn-static-auth-secret";
    realm = "turn.${config.pub-solar-os.networking.domain}";
    cert = "${config.security.acme.certs.${realm}.directory}/full.pem";
    pkey = "${config.security.acme.certs.${realm}.directory}/key.pem";
    extraConfig =
      let
        externalIPv4s = lib.strings.concatMapStringsSep "\n" ({ address, ... }: "external-ip=${address}") config.networking.interfaces.enp35s0.ipv4.addresses;
        externalIPv6s = lib.strings.concatMapStringsSep "\n" ({ address, ... }: "external-ip=${address}") config.networking.interfaces.enp35s0.ipv6.addresses;
      in
      ''
        ${externalIPv4s}
        ${externalIPv6s}

        no-tlsv1
        no-tlsv1_1

        no-rfc5780
        response-origin-only-with-rfc5780

        prod

        no-stun-backward-compatibility

        # ban private IP ranges
        no-multicast-peers
        denied-peer-ip=0.0.0.0-0.255.255.255
        denied-peer-ip=10.0.0.0-10.255.255.255
        denied-peer-ip=100.64.0.0-100.127.255.255
        denied-peer-ip=127.0.0.0-127.255.255.255
        denied-peer-ip=169.254.0.0-169.254.255.255
        denied-peer-ip=172.16.0.0-172.31.255.255
        denied-peer-ip=192.0.0.0-192.0.0.255
        denied-peer-ip=192.0.2.0-192.0.2.255
        denied-peer-ip=192.88.99.0-192.88.99.255
        denied-peer-ip=192.168.0.0-192.168.255.255
        denied-peer-ip=198.18.0.0-198.19.255.255
        denied-peer-ip=198.51.100.0-198.51.100.255
        denied-peer-ip=203.0.113.0-203.0.113.255
        denied-peer-ip=240.0.0.0-255.255.255.255
        denied-peer-ip=::1
        denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
        denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
        denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
        denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      '';

  };

  networking.firewall = {
    interfaces.enp35s0 =
      let
        range = with config.services.coturn; [{
          from = min-port;
          to = max-port;
        }];
      in
      {
        allowedUDPPortRanges = range;
        allowedUDPPorts = [ 3478 5349 ];
        allowedTCPPortRanges = [ ];
        allowedTCPPorts = [ 3478 5349 ];
      };
  };

  # get a certificate
  security.acme.certs.${config.services.coturn.realm} = {
    /* insert here the right configuration to obtain a certificate */
    postRun = "systemctl restart coturn.service";
    group = "turnserver";
  };
  services.nginx.virtualHosts.${config.services.coturn.realm} = {
    enableACME = true;
    addSSL = true;
    globalRedirect = "${config.pub-solar-os.networking.domain}";
  };

  users.users.nginx.extraGroups = [ "turnserver" ];
}
