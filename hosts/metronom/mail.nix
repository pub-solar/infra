{ config, flake, ... }:

{
  age.secrets.mail-hensoko.file = "${flake.self}/secrets/mail/hensoko.age";

  mailserver = {
    enable = true;
    fqdn = "metronom.pub.solar";
    domains = [ "pub.solar" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -R11 -m bcrypt'
    loginAccounts = {
      "hensoko@pub.solar" = {
        hashedPasswordFile = config.age.secrets.mail-hensoko.path;
        aliases = [ "postmaster@pub.solar" ];
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@pub.solar";
}
