{ flake, pkgs, ... }: {
  users.users.${flake.self.username} = {
    name = flake.self.username;
    group = flake.self.username;
    extraGroups = [ "wheel" "docker" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = flake.self.logins.admins.sshPubKeys;
  };
  users.groups.${flake.self.username} = { };

  # TODO: Remove when we stop locking ourselves out.
  users.users.root.openssh.authorizedKeys.keys = flake.self.logins.admins.sshPubKeys;

  users.users.hakkonaut = {
    description = "CI and automation user";
    home = "/home/hakkonaut";
    createHome = true;
    useDefaultShell = true;
    uid = 998;
    group = "hakkonaut";
    isSystemUser = true;
    openssh.authorizedKeys.keys = flake.self.logins.robots.sshPubKeys;
  };

  users.groups.hakkonaut = { };

  users.users.root.initialHashedPassword = "$y$j9T$bIN6GjQkmPMllOcQsq52K0$q0Z5B5.KW/uxXK9fItB8H6HO79RYAcI/ZZdB0Djke32";

  security.sudo.wheelNeedsPassword = false;
}
