{
  pkgs,
  flake,
  ...
}:
let
  ca-cert = pkgs.writeTextFile {
    name = "ca-cert";
    text = builtins.readFile ./step/certs/root_ca.crt;
  };
in
{
  imports = [
    flake.self.inputs.agenix.nixosModules.default
    flake.self.nixosModules.backups
    flake.self.nixosModules.nginx
    flake.self.nixosModules.keycloak
    flake.self.nixosModules.postgresql
    ./global.nix
  ];

  virtualisation.cores = 4;
  virtualisation.memorySize = 4096;

  systemd.tmpfiles.rules = [
    "f /tmp/dbf 1777 root root 10d password"
  ];

  pub-solar-os.auth = {
    enable = true;
    database-password-file = "/tmp/dbf";
  };
  services.keycloak.database.createLocally = true;
  services.keycloak.initialAdminPassword = "password";
  services.keycloak.settings.truststore-paths = "${ca-cert}";
  systemd.services.keycloak.serviceConfig.TimeoutSec = 900;
}
