{
  self,
  system,
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
    dns-server.imports = [ ./support/dns-server.nix ];
    acme-server.imports = [ ./support/acme-server.nix ];
    mail-server.imports = [ ./support/mail-server.nix ];
    auth-server.imports = [ ./support/auth-server.nix ];
    client.imports = [ ./support/client.nix ];
  };

  testScript =
    { nodes, ... }:
    let
      user = nodes.client.users.users.test-user;
      #uid = toString user.uid;
      bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ${user.name})/bus";
      gdbus = "${bus} gdbus";
      su = command: "su - ${user.name} -c '${command}'";
      gseval = "call --session -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval";
      wmClass = su "${gdbus} ${gseval} global.display.focus_window.wm_class";
    in
    ''
      import time
      import re
      import sys

      def puppeteer_run(cmd):
        client.succeed(f'puppeteer-run \'{cmd}\' ')

      start_all()

      acme_server.wait_for_unit("system.slice")
      mail_server.wait_for_unit("dovecot2.service")
      mail_server.wait_for_unit("postfix.service")
      mail_server.wait_for_unit("nginx.service")
      mail_server.wait_until_succeeds("curl http://mail.test.pub.solar/")

      auth_server.wait_for_unit("system.slice")
      auth_server.succeed("ping 127.0.0.1 -c 2")
      auth_server.wait_for_unit("nginx.service")

      auth_server.wait_for_unit("keycloak.service")
      auth_server.wait_for_open_port(8080)
      auth_server.wait_for_open_port(443)
      auth_server.wait_until_succeeds("curl http://127.0.0.1:8080/")
      auth_server.wait_until_succeeds("curl https://auth.test.pub.solar/")
      auth_server.succeed("${pkgs.keycloak}/bin/kcadm.sh create realms -f ${realm-export} --server http://localhost:8080 --realm master --user admin --password password --no-config")

      client.wait_for_unit("system.slice")
      client.wait_for_file("/tmp/puppeteer.sock")

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
      puppeteer_run('page.locator("input[type=submit][value=Register]").click()')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("after-register")

      client.succeed("${su "offlineimap"}")
      client.succeed("${su "[ $(messages -s ~/Maildir/test-user@test.pub.solar/INBOX) -eq 1 ]"}")

      puppeteer_run('page.locator("a::-p-text(Click here)").click()')
      puppeteer_run('page.waitForNetworkIdle()')

      client.succeed("${su "offlineimap"}")
      client.succeed("${su "[ $(messages -s ~/Maildir/test-user@test.pub.solar/INBOX) -eq 2 ]"}")
      mail_text = client.execute("${su "echo p | mail -Nf ~/Maildir/test-user@test.pub.solar/INBOX"}")[1]
      boundary_match = re.search('boundary="(.*)"', mail_text, flags=re.M)
      if not boundary_match:
        sys.exit(1)
      splits = mail_text.split(f'--{boundary_match.group(1)}')
      clean_plaintext = splits[1].replace("=\n", "").replace("=3D", "=")
      url_match = re.search('(https://auth.test.pub.solar.*)', clean_plaintext, flags=re.M)
      print(url_match)
      if not url_match:
        sys.exit(1)
      puppeteer_run(f'page.goto("{url_match.group(1)}")')
      puppeteer_run('page.waitForNetworkIdle()')
      client.screenshot("email-confirmed")

      sys.exit(0)
      time.sleep(1)
    '';
}
