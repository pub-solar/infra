{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
{
  options.pub-solar-os.authentication =
    let
      inherit (lib) mkOption types;
    in
    {
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
    users.users =
      (lib.attrsets.foldlAttrs (
        acc: name: value:
        acc
        // {
          ${name} = {
            name = name;
            group = name;
            extraGroups = [
              "wheel"
              "docker"
            ];
            isNormalUser = true;
            openssh.authorizedKeys.keys = lib.attrsets.attrValues value.sshPubKeys;
          };
        }
      ) { } flake.self.logins.admins)
      // {
        # TODO: Remove when we stop locking ourselves out.
        root.openssh.authorizedKeys.keys = flake.self.logins.sshPubKeys;
        root.initialHashedPassword = config.pub-solar-os.authentication.root.initialHashedPassword;

        ${config.pub-solar-os.authentication.robot.username} = {
          description = "CI and automation user";
          home = "/home/${config.pub-solar-os.authentication.robot.username}";
          createHome = true;
          useDefaultShell = true;
          uid = 1100;
          group = "${config.pub-solar-os.authentication.robot.username}";
          isSystemUser = true;
          openssh.authorizedKeys.keys = config.pub-solar-os.authentication.robot.sshPubKeys;
        };
      };

    home-manager.users = (
      lib.attrsets.foldlAttrs (
        acc: name: value:
        acc
        // {
          ${name} = {
            home.stateVersion = "23.05";
          };
        }
      ) { } flake.self.logins.admins
    );

    users.groups =
      (lib.attrsets.foldlAttrs (
        acc: name: value:
        acc // { "${name}" = { }; }
      ) { } flake.self.logins.admins)
      // {
        ${config.pub-solar-os.authentication.robot.username} = {
          gid = 1100;
        };
      };

    security.sudo.wheelNeedsPassword = false;
  };
}
