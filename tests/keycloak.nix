{
  self,
  pkgs,
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
    net-server.imports = [ ./support/net-server.nix ];
    mail-server.imports = [ ./support/mail-server.nix ];
    auth-server.imports = [ ./support/auth-server.nix ];
    client.imports = [ ./support/client.nix ];
  };

  testScript =
    { nodes, ... }:
    let
      user = nodes.client.users.users.test-user;
      su = command: "su - ${user.name} -c '${command}'";
    in
    ''
      import time
      import re
      import sys

      def puppeteer_succeed(cmd):
        return client.succeed(f'puppeteer-run \'{cmd}\' ')

      def puppeteer_execute(cmd):
        return client.execute(f'puppeteer-run \'{cmd}\' ')

      def puppeteer_scroll_into_view(selector):
        return puppeteer_succeed(f'(async () => {{ const el = await page.$(`{selector}`); console.log(el); return el.scrollIntoView(); }})()')

      start_all()

      net_server.wait_for_unit("default.target")
      net_server.wait_for_unit("unbound.service")
      net_server.wait_for_unit("step-ca.service")
      net_server.wait_for_open_port(443)
      net_server.succeed("ping ca.test.pub.solar -c 2")

      auth_server.wait_for_unit("keycloak.service")
      auth_server.wait_until_succeeds("curl http://127.0.0.1:8080/")
      auth_server.succeed("${pkgs.keycloak}/bin/kcadm.sh create realms -f ${realm-export} --server http://localhost:8080 --realm master --user admin --password password --no-config")
      auth_server.wait_until_succeeds("curl https://auth.test.pub.solar/")

      client.wait_for_file("/tmp/puppeteer.sock")

      ####### Registration #######

      puppeteer_succeed('page.goto("https://auth.test.pub.solar")')
      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("initial")
      puppeteer_succeed('page.locator("::-p-text(Sign in)").click()')
      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("sign-in")
      puppeteer_succeed('page.locator("::-p-text(Register)").click()')
      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("register")
      puppeteer_succeed('page.locator("[name=username]").fill("test-user")')
      puppeteer_succeed('page.locator("[name=email]").fill("test-user@test.pub.solar")')
      puppeteer_succeed('page.locator("[name=password]").fill("Password1234")')
      puppeteer_succeed('page.locator("[name=password-confirm]").fill("Password1234")')
      client.screenshot("register-filled-in")

      # Make sure the mail server is ready to send
      mail_server.wait_for_unit("dovecot2.service")
      mail_server.wait_for_unit("postfix.service")
      mail_server.wait_for_unit("rspamd.service")

      mail_server.wait_until_succeeds("curl http://mail.test.pub.solar/")
      puppeteer_succeed('page.locator("input[type=submit][value=Register]").click()')
      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("before-email-confirm")

      # Sometimes offlineimap errors out
      # ERROR: [Errno 2] No such file or directory: '/home/test-user/.local/share/offlineimap'
      client.succeed("${su "mkdir -p ~/.local/share/offlineimap"}")

      client.succeed("${su "offlineimap"}")
      client.succeed("${su "[ $(messages -s ~/Maildir/test-user@test.pub.solar/INBOX) -eq 1 ]"}")

      puppeteer_succeed('page.locator("a::-p-text(Click here)").click()')
      puppeteer_succeed('page.waitForNetworkIdle()')

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
      puppeteer_succeed(f'page.goto("{url_match.group(1)}")')
      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("registration-complete")

      ####### Logout #######

      puppeteer_succeed('page.locator("[data-testid=options-toggle]").click()')
      puppeteer_succeed('page.locator("::-p-text(Sign out)").click()')

      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("logged-out")

      ####### Login plain #######

      puppeteer_succeed('page.locator("[name=username]").fill("test-user")')
      puppeteer_succeed('page.locator("::-p-text(Sign In)").click()')
      puppeteer_succeed('page.locator("::-p-text(Restart login)").click()')

      puppeteer_succeed('page.locator("[name=username]").fill("test-user")')
      puppeteer_succeed('page.locator("::-p-text(Sign In)").click()')
      puppeteer_succeed('page.locator("[name=password]").fill("Password1234")')
      puppeteer_succeed('page.locator("::-p-text(Sign In)").click()')

      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("logged-in")

      ####### Add TOTP #######

      puppeteer_succeed('page.locator("::-p-text(Account security)").click()')
      puppeteer_succeed('page.locator("::-p-text(Signing in)").click()')

      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("signing-in-settings")

      puppeteer_succeed('page.locator(`[data-testid="otp/create"]`).click()')

      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("TOTP-setup-qr")

      puppeteer_succeed('page.locator("::-p-text(Unable to scan?)").click()')

      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("TOTP-setup-manual")

      totp_secret_key = puppeteer_execute('(async () => { const el = await page.waitForSelector("#kc-totp-secret-key"); return el.evaluate(e => e.textContent); })()')[1]

      totp = client.execute(f'oathtool --totp -b "{totp_secret_key}"')[1].replace("\n", "")

      puppeteer_succeed(f'page.locator("[name=totp]").fill("{totp}")')
      puppeteer_succeed('page.locator("[name=userLabel]").fill("My TOTP")')
      client.screenshot("TOTP-form-filled")
      puppeteer_succeed('page.locator("input[type=submit][value=Submit]").click()')

      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("TOTP-added")

      ####### Login w/ TOTP #######

      puppeteer_succeed('page.locator("[data-testid=options-toggle]").click()')
      puppeteer_succeed('page.locator("::-p-text(Sign out)").click()')

      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("logged-out")

      puppeteer_succeed('page.locator("[name=username]").fill("test-user")')
      puppeteer_succeed('page.locator("::-p-text(Sign In)").click()')
      puppeteer_succeed('page.locator("[name=password]").fill("Password1234")')
      puppeteer_succeed('page.locator("::-p-text(Sign In)").click()')

      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("TOTP-login-form")

      print('Setting all system clocks 30 seconds ahead for next TOTP token')
      client.execute("date --set='+30 seconds'");
      auth_server.execute("date --set='+30 seconds'");
      net_server.execute("date --set='+30 seconds'");
      net_server.execute("date --set='+30 seconds'");
      mail_server.execute("date --set='+30 seconds'");

      totp = client.execute(f'oathtool --totp -b "{totp_secret_key}"')[1].replace("\n", "")

      puppeteer_succeed(f'page.locator("[name=otp]").fill("{totp}")')
      puppeteer_succeed('page.locator("::-p-text(Sign In)").click()')

      puppeteer_succeed('page.waitForNetworkIdle()')
      client.screenshot("TOTP-signed-in")

      ####### Delete TOTP #######

      puppeteer_scroll_into_view('[data-testid="otp/credential-list"]')
      time.sleep(0.2)
      client.screenshot("TOTP-before-delete")

      # puppeteer_succeed('page.locator(`[data-testid="otp/credential-list"] button::-p-text(Delete)`).click()')
      # client.screenshot("TOTP-deleted")
    '';
}
