{
  self,
  pkgs,
  lib,
  config,
  ...
}: let
in {
  name = "keycloak";

  hostPkgs = pkgs;

  node.pkgs = pkgs;
  node.specialArgs = self.outputs.nixosConfigurations.nachtigall._module.specialArgs;

  nodes = {
    acme-server = {
      imports = [
        self.nixosModules.home-manager
        self.nixosModules.core
        ./support/ca.nix
      ];
    };

    client = {
      imports = [
        self.nixosModules.home-manager
        self.nixosModules.core
        ./support/client.nix
      ];
    };

    nachtigall = {
      imports = [
        self.inputs.agenix.nixosModules.default
        self.nixosModules.home-manager
        self.nixosModules.core
        self.nixosModules.backups
        self.nixosModules.nginx
        self.nixosModules.keycloak
        self.nixosModules.postgresql
        ./support/global.nix
      ];

      systemd.tmpfiles.rules = [
        "f /tmp/dbf 1777 root root 10d"
      ];

      pub-solar-os.auth = {
        enable = true;
        database-password-file = "/tmp/dbf";
      };

      networking.interfaces.eth0.ipv4.addresses = [
        {
          address = "192.168.1.3";
          prefixLength = 32;
        }
      ];
    };
  };

  enableOCR = true;

  testScript = ''
    start_all()

    nachtigall.wait_for_unit("system.slice")
    nachtigall.succeed("ping 127.0.0.1 -c 2")
    nachtigall.wait_for_unit("nginx.service")
    nachtigall.wait_for_unit("keycloak.service")
    nachtigall.succeed("curl https://auth.test.pub.solar/")

    client.wait_for_unit("system.slice")
    client.wait_until_succeeds("swaymsg -t get_tree | grep -q 'firefox'")
    client.sleep(20)
    client.screenshot("screen")
  '';
}
