{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
{
  options.pub-solar-os.authentication = with lib; {
    username = mkOption {
      description = "Username for the adminstrative user";
      type = types.str;
      default = flake.self.username;
    };

    sshPubKeys = mkOption {
      description = "SSH Keys that should have administrative root access";
      type = types.listOf types.str;
      default = flake.self.logins.admins.sshPubKeys;
    };

    root.initialHashedPassword = mkOption {
      description = "Hashed password of the root account";
      type = types.str;
      default = "$y$j9T$bIN6GjQkmPMllOcQsq52K0$q0Z5B5.KW/uxXK9fItB8H6HO79RYAcI/ZZdB0Djke32";
    };

    robot.username = mkOption {
      description = "username for the robot user";
      type = types.str;
      default = "hakkonaut";
    };

    robot.sshPubKeys = mkOption {
      description = "SSH Keys to use for the robot user";
      type = types.listOf types.str;
      default = flake.self.logins.robots.sshPubKeys;
    };
  };

  config = {
    users.users.${config.pub-solar-os.authentication.username} = {
      name = config.pub-solar-os.authentication.username;
      group = config.pub-solar-os.authentication.username;
      extraGroups = [
        "wheel"
        "docker"
      ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = config.pub-solar-os.authentication.sshPubKeys;
    };
    users.groups.${config.pub-solar-os.authentication.username} = { };

    # TODO: Remove when we stop locking ourselves out.
    users.users.root.openssh.authorizedKeys.keys = config.pub-solar-os.authentication.sshPubKeys;

    users.users.${config.pub-solar-os.authentication.robot.username} = {
      description = "CI and automation user";
      home = "/home/${config.pub-solar-os.authentication.robot.username}";
      createHome = true;
      useDefaultShell = true;
      uid = 998;
      group = "${config.pub-solar-os.authentication.robot.username}";
      isSystemUser = true;
      openssh.authorizedKeys.keys = config.pub-solar-os.authentication.robot.sshPubKeys;
    };

    users.groups.${config.pub-solar-os.authentication.robot.username} = { };

    users.users.root.initialHashedPassword =
      config.pub-solar-os.authentication.root.initialHashedPassword;

    security.sudo.wheelNeedsPassword = false;
  };
}
