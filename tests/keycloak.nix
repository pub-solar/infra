{
  self,
  pkgs,
  lib,
  config,
  ...
}:
let
in
{
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

      systemd.tmpfiles.rules = [ "f /tmp/dbf 1777 root root 10d password" ];

      virtualisation.cores = 1;
      virtualisation.memorySize = 4096;

      pub-solar-os.auth = {
        enable = true;
        database-password-file = "/tmp/dbf";
      };
      services.keycloak.database.createLocally = true;

      networking.interfaces.eth0.ipv4.addresses = [
        {
          address = "192.168.1.3";
          prefixLength = 32;
        }
      ];
    };
  };

  testScript =
    { nodes, ... }:
    let
      user = nodes.client.users.users.b12f;
      #uid = toString user.uid;
      bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ${user.name})/bus";
      gdbus = "${bus} gdbus";
      su = command: "su - ${user.name} -c '${command}'";
      gseval = "call --session -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval";
      wmClass = su "${gdbus} ${gseval} global.display.focus_window.wm_class";
    in
    ''
      acme_server.start()

      acme_server.wait_for_unit("default.target")
      acme_server.wait_for_unit("step-ca.service")
      acme_server.succeed("ping ca.test.pub.solar -c 2")
      acme_server.wait_for_open_port(443)
      acme_server.wait_until_succeeds("curl 127.0.0.1:443")

      nachtigall.start()
      nachtigall.wait_for_unit("default.target")
      nachtigall.succeed("ping 127.0.0.1 -c 2")
      nachtigall.wait_for_unit("nginx.service")
      nachtigall.wait_for_unit("keycloak.service")
      nachtigall.wait_for_open_port(8080)
      nachtigall.wait_for_open_port(443)
      nachtigall.wait_until_succeeds("curl http://127.0.0.1:8080/")
      nachtigall.wait_until_succeeds("curl https://auth.test.pub.solar/")

      client.start()
      client.wait_for_unit("default.target")
      # client.wait_until_succeeds("${wmClass} | grep -q 'firefox'")
      client.screenshot("screen")
    '';
}
