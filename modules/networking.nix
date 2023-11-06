{ pkgs, ... }: {
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.openssh.settings.PasswordAuthentication = false;

  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=193.110.81.0#dns0.eu 185.253.5.0#dns0.eu 2a0f:fc80::#dns0.eu 2a0f:fc81::#dns0.eu 9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
      FallbackDNS=5.1.66.255#dot.ffmuc.net 185.150.99.255#dot.ffmuc.net 2001:678:e68:f000::#dot.ffmuc.net 2001:678:ed0:f000::#dot.ffmuc.net
      Domains=~.
      DNSOverTLS=yes
    '';
  };
}
