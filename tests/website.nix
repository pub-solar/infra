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
    net-server.imports = [ ./support/net-server.nix ];

    web-server = {
      imports = [
        self.nixosModules.home-manager
        self.nixosModules.nginx
        self.nixosModules.nginx-website
        ./support/global.nix
      ];
    };
  };

  testScript = ''
    start_all()

    net_server.wait_for_unit("default.target")
    net_server.wait_for_unit("unbound.service")
    net_server.wait_for_unit("step-ca.service")
    net_server.wait_for_open_port(443)
    net_server.succeed("ping ca.test.pub.solar -c 2")

    web_server.wait_for_unit("default.target")
    web_server.wait_for_unit("nginx.service")
    web_server.wait_until_succeeds("curl https://test.pub.solar/")
  '';
}
