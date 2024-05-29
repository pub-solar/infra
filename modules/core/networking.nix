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

    networking.hosts = {
      "138.201.80.102" = [ "git.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.1" = [ "nachtigall.${config.pub-solar-os.networking.domain}" ];
      "10.7.6.2" = [ "flora-6.${config.pub-solar-os.networking.domain}" ];
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

    services.resolved = {
      enable = true;
      extraConfig = ''
        DNS=193.110.81.0#dns0.eu 185.253.5.0#dns0.eu 2a0f:fc80::#dns0.eu 2a0f:fc81::#dns0.eu 9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
        FallbackDNS=5.1.66.255#dot.ffmuc.net 185.150.99.255#dot.ffmuc.net 2001:678:e68:f000::#dot.ffmuc.net 2001:678:ed0:f000::#dot.ffmuc.net
        Domains=~.
        DNSOverTLS=yes
      '';
    };
  };
}
