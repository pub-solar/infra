{
  self,
  pkgs,
  lib,
  config,
  ...
}:
let
  realm-export = pkgs.writeTextFile {
    name = "realm-export.json";
    text = builtins.readFile ./support/keycloak-realm-export/realm-export.json;
  };
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
    { ... }: ''
      def puppeteer_run(cmd):
          client.succeed(f'puppeteer-run \'{cmd}\' ')

      start_all()

      nachtigall.wait_for_unit("system.slice")
      nachtigall.succeed("ping 127.0.0.1 -c 2")
      nachtigall.wait_for_unit("nginx.service")

      nachtigall.systemctl("stop keycloak.service")
      nachtigall.wait_until_succeeds("if (($(ps aux | grep 'Dkc.home.dir=/run/keycloak' | grep -v grep | wc -l) == 0)); then true; else false; fi")
      nachtigall.succeed("${pkgs.keycloak}/bin/kc.sh --verbose import --optimized --file=${realm-export}")
      nachtigall.systemctl("start keycloak.service")
      nachtigall.sleep(30)
      nachtigall.wait_until_succeeds("curl http://127.0.0.1:8080/")
      nachtigall.wait_until_succeeds("curl https://auth.test.pub.solar/")

      client.wait_for_unit("system.slice")
      client.wait_for_file("/tmp/puppeteer.sock")

      puppeteer_run('page.goto("https://auth.test.pub.solar/admin/master/console")')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("admin-initial")
      puppeteer_run('page.locator("[name=username]").fill("admin")')
      puppeteer_run('page.locator("::-p-text(Sign In)").click()')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("admin-password")
      puppeteer_run('page.locator("[name=password]").fill("password")')
      puppeteer_run('page.locator("::-p-text(Sign In)").click()')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("admin-login")
      puppeteer_run('page.locator("::-p-text(Realm settings)").click()')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("admin-theme")
      puppeteer_run('page.locator("::-p-text(Themes)").click()')
      puppeteer_run('page.waitForNetworkIdle()')
      puppeteer_run('page.locator("#kc-login-theme").click()')
      client.screenshot("admin-theme-changed")
      puppeteer_run('page.locator("li button::-p-text(pub.solar)").click()')
      puppeteer_run('page.locator("::-p-text(Save)").click()')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("admin-theme-saved")



      puppeteer_run('page.goto("https://auth.test.pub.solar")')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("initial")
      puppeteer_run('page.locator("::-p-text(Sign in)").click()')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("sign-in")
      puppeteer_run('page.locator("::-p-text(Register)").click()')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("register")
      puppeteer_run('page.locator("[name=username]").fill("test-user")')
      puppeteer_run('page.locator("[name=email]").fill("test-user@test.pub.solar")')
      puppeteer_run('page.locator("[name=password]").fill("Password1234")')
      puppeteer_run('page.locator("[name=password-confirm]").fill("Password1234")')
      client.screenshot("register-filled-in")
      puppeteer_run('page.locator("button::-p-text(Register)").click()')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("after-register")
    '';
}
