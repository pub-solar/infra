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

      virtualisation.cores = 1;
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
    acme_server.start()

    acme_server.wait_for_unit("default.target")
    acme_server.wait_for_unit("step-ca.service")
    acme_server.succeed("ping ca.test.pub.solar -c 2")
    acme_server.wait_for_open_port(443)
    acme_server.wait_until_succeeds("curl 127.0.0.1:443")

    nachtigall.start()
    nachtigall.wait_for_unit("default.target")
    nachtigall.succeed("ping test.pub.solar -c 2")
    nachtigall.succeed("ping ca.test.pub.solar -c 2")
    nachtigall.wait_for_unit("nginx.service")
    nachtigall.wait_for_open_port(443, "test.pub.solar")
    nachtigall.wait_until_succeeds("curl https://test.pub.solar/")
  '';
}
