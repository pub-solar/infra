{
  self,
  pkgs,
  lib,
  config,
  ...
}: {
  name = "website";

  nodes.nachtigall-test = self.nixosConfigurations.nachtigall-test;

  node.specialArgs = self.outputs.nixosConfigurations.nachtigall._module.specialArgs;
  hostPkgs = pkgs;

  enableOCR = true;

  testScript = ''
    machine.wait_for_unit("system.slice")
    machine.succeed("ping 127.0.0.1 -c 2")
    machine.wait_for_unit("nginx.service")
    machine.succeed("curl -H 'Host:pub.solar' http://127.0.0.1/")
  '';
}
