{
  pkgs,
  flake,
  ...
}:let
  ca-cert = pkgs.writeTextFile {
    name = "ca-cert";
    text = builtins.readFile ./step/certs/root_ca.crt;
  };
in {
  imports = [
    flake.self.inputs.agenix.nixosModules.default
    flake.self.nixosModules.home-manager
    flake.self.nixosModules.core
    flake.self.nixosModules.backups
    flake.self.nixosModules.nginx
    flake.self.nixosModules.keycloak
    flake.self.nixosModules.postgresql
    ./global.nix
  ];

  systemd.tmpfiles.rules = [
    "f /tmp/dbf 1777 root root 10d password"
  ];

  virtualisation.memorySize = 4096;

  pub-solar-os.auth = {
    enable = true;
    database-password-file = "/tmp/dbf";
  };
  services.keycloak.database.createLocally = true;
  services.keycloak.initialAdminPassword = "password";
  services.keycloak.settings.truststore-paths = "${ca-cert}";
}
