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

  nodes.nachtigall-test = {
    imports = [
      self.nixosModules.home-manager
      self.nixosModules.core
      self.nixosModules.nginx
      self.nixosModules.nginx-website
    ];
  };

  enableOCR = true;

  testScript = ''
    nachtigall_test.wait_for_unit("system.slice")
    nachtigall_test.succeed("ping 127.0.0.1 -c 2")
    nachtigall_test.wait_for_unit("nginx.service")
    nachtigall_test.succeed("curl -H 'Host:pub.solar' http://127.0.0.1/")
  '';
}
