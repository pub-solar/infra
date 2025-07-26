{
  config,
  lib,
  ...
}:

let
  cfg = config.pub-solar-os.coturn;
  domain = "turn.${config.pub-solar-os.networking.domain}";
  listeningPort = 3478;
  tlsListeningPort = 5349;
  altListeningPort = 3479;
  altTlsListeningPort = 5350;
in
{
  options.pub-solar-os.coturn = with lib; {
    enable = mkEnableOption "enable coturn";
    staticAuthSecretFile = mkOption {
      description = "File that holds the static auth secret";
      type = types.str;
    };
    interface = mkOption {
      description = "Interface coturn should listen on";
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.coturn = {
      enable = true;
      no-cli = true;
      min-port = 49000;
      max-port = 50000;
      listening-port = listeningPort;
      tls-listening-port = tlsListeningPort;
      alt-listening-port = altListeningPort;
      alt-tls-listening-port = altTlsListeningPort;
      use-auth-secret = true;
      static-auth-secret-file = config.pub-solar-os.coturn.staticAuthSecretFile;
      realm = domain;
      cert = "${config.security.acme.certs.${domain}.directory}/full.pem";
      pkey = "${config.security.acme.certs.${domain}.directory}/key.pem";
      relay-ips =
        let
          toIPs = setList: map (set: set.address) setList;
        in
        (toIPs config.networking.interfaces.${config.pub-solar-os.coturn.interface}.ipv4.addresses)
        ++ toIPs (config.networking.interfaces.${config.pub-solar-os.coturn.interface}.ipv6.addresses);
      no-tcp-relay = true;
      extraConfig =
        let
          externalIPv4s = lib.strings.concatMapStringsSep "\n" (
            { address, ... }: "external-ip=${address}"
          ) config.networking.interfaces.${config.pub-solar-os.coturn.interface}.ipv4.addresses;
          externalIPv6s = lib.strings.concatMapStringsSep "\n" (
            { address, ... }: "external-ip=${address}"
          ) config.networking.interfaces.${config.pub-solar-os.coturn.interface}.ipv6.addresses;
        in
        ''
          ${externalIPv4s}
          ${externalIPv6s}

          cipher-list=\"HIGH\"

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
      allowedUDPPortRanges = with config.services.coturn; [
        {
          from = min-port;
          to = max-port;
        }
      ];
      allowedUDPPorts = [
        listeningPort
        altListeningPort
      ];
      allowedTCPPortRanges = [ ];
      allowedTCPPorts = [
        listeningPort
        tlsListeningPort
        altListeningPort
        altTlsListeningPort
      ];
    };

    # get a certificate
    services.nginx = {
      enable = true;
      virtualHosts = {
        "${domain}" = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };
    security.acme.certs.${config.services.coturn.realm} = {
      postRun = "systemctl restart coturn.service";
      group = "turnserver";
    };

    users.users.nginx.extraGroups = [ "turnserver" ];
  };
}
