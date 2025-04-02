{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.pub-solar-os.networking =
    let
      inherit (lib) mkOption types;
    in
    {
      domain = mkOption {
        description = "domain on which all services should run. This defaults to pub.solar";
        type = types.str;
        default = "pub.solar";
      };

      defaultInterface = mkOption {
        description = "Network interface which should be used as the default internet-connected one";
        type = types.nullOr types.str;
      };
    };

  config = {

    # Don't expose SSH via public interfaces
    networking.firewall.interfaces.wg-ssh.allowedTCPPorts = [ 22 ];

    networking.domain = config.pub-solar-os.networking.domain;

    networking.hosts = {
      "10.7.6.1" = [ "nachtigall.wg.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.3" = [ "metronom.wg.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.4" = [ "tankstelle.wg.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.5" = [ "trinkgenossin.wg.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.6" = [ "delite.wg.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.7" = [ "blue-shell.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:1::" = [ "nachtigall.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:3::" = [ "metronom.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:4::" = [ "tankstelle.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:5::" = [ "trinkgenossin.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:6::" = [ "delite.wg.${config.pub-solar-os.networking.domain}" ];
      "fd00:fae:fae:fae:fae:7::" = [ "blue-shell.wg.${config.pub-solar-os.networking.domain}" ];
    };

    services.openssh = {
      enable = true;
      openFirewall = lib.mkDefault false;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        # Add back openssh MACs that got removed from defaults
        # for backwards compatibility
        #
        # NixOS default openssh MACs have changed to use "encrypt-then-mac" only.
        # This breaks compatibilty with clients that do not offer these MACs. For
        # compatibility reasons, we add back the old defaults.
        # See: https://github.com/NixOS/nixpkgs/pull/231165
        #
        # https://blog.stribik.technology/2015/01/04/secure-secure-shell.html
        # https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
          "hmac-sha2-512"
          "hmac-sha2-256"
          "umac-128@openssh.com"
        ];
      };
    };

    # These nameservers land in resolved.conf as 'DNS=<list>'
    networking.nameservers = [
      "193.110.81.0#dns0.eu"
      "185.253.5.0#dns0.eu"
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
      "2a0f:fc80::#dns0.eu"
      "2a0f:fc81::#dns0.eu"
      "2620:fe::fe#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
    ];
    services.resolved = {
      enable = true;
      dnsovertls = "true";
      # default value in nixos module
      dnssec = "false";
      domains = [
        "~."
      ];
      fallbackDns = [
        "5.1.66.255#dot.ffmuc.net"
        "185.150.99.255#dot.ffmuc.net"
        "2001:678:e68:f000::#dot.ffmuc.net"
        "2001:678:ed0:f000::#dot.ffmuc.net"
      ];
    };
  };
}
