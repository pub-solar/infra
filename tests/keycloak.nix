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
        "f /tmp/dbf 1777 root root 10d password"
      ];

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

  enableOCR = true;

  testScript = {nodes, ...}: let
    user = nodes.client.users.users.${nodes.client.pub-solar-os.authentication.username};
    #uid = toString user.uid;
    bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ${user.name})/bus";
    gdbus = "${bus} gdbus";
    su = command: "su - ${user.name} -c '${command}'";
    gseval = "call --session -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval";
    wmClass = su "${gdbus} ${gseval} global.display.focus_window.wm_class";
  in ''
    start_all()

    nachtigall.wait_for_unit("system.slice")
    nachtigall.succeed("ping 127.0.0.1 -c 2")
    nachtigall.wait_for_unit("nginx.service")
    nachtigall.wait_for_unit("keycloak.service")
    nachtigall.wait_until_succeeds("curl http://127.0.0.1:8080/")
    nachtigall.wait_until_succeeds("curl https://auth.test.pub.solar/")

    client.wait_for_unit("system.slice")
    client.sleep(30)
    # client.wait_until_succeeds("${wmClass} | grep -q 'firefox'")
    client.screenshot("screen")
  '';
}
