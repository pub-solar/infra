{ pkgs, lib, ... }: {
  # Don't expose SSH via public interfaces
  networking.firewall.interfaces.wg-ssh.allowedTCPPorts = [ 22 ];

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
    # DNSSEC=false because of random SERVFAIL responses with Greenbaum DNS
    # when using allow-downgrade, see https://github.com/systemd/systemd/issues/10579
    extraConfig = ''
      DNS=193.110.81.0#dns0.eu 185.253.5.0#dns0.eu 2a0f:fc80::#dns0.eu 2a0f:fc81::#dns0.eu 9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
      FallbackDNS=5.1.66.255#dot.ffmuc.net 185.150.99.255#dot.ffmuc.net 2001:678:e68:f000::#dot.ffmuc.net 2001:678:ed0:f000::#dot.ffmuc.net
      Domains=~.
      DNSOverTLS=yes
      DNSSEC=false
    '';
  };
}
