{
  self,
  pkgs,
  lib,
  config,
  ...
}:
{
  name = "website";

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

    nachtigall = {
      imports = [
        self.nixosModules.home-manager
        self.nixosModules.core
        self.nixosModules.nginx
        self.nixosModules.nginx-website
        ./support/global.nix
      ];

      virtualisation.memorySize = 4096;

      networking.interfaces.eth0.ipv4.addresses = [
        {
          address = "192.168.1.3";
          prefixLength = 32;
        }
      ];
    };
  };

  testScript = ''
    start_all()

    acme_server.wait_for_unit("system.slice")
    acme_server.wait_for_unit("step-ca.service")
    acme_server.succeed("ping ca.test.pub.solar -c 2")
    acme_server.wait_until_succeeds("curl 127.0.0.1:443")

    nachtigall.wait_for_unit("system.slice")
    nachtigall.succeed("ping test.pub.solar -c 2")
    nachtigall.succeed("ping ca.test.pub.solar -c 2")
    nachtigall.wait_for_unit("nginx.service")
    nachtigall.wait_until_succeeds("curl https://test.pub.solar/")
  '';
}
