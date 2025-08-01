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
      users = mkOption {
        description = "Administrative users to add";

        type = types.attrsOf (
          types.submodule {
            options = {
              sshPubKeys = mkOption {
                type = types.attrsOf types.str;
                default = { };
              };
              secretEncryptionKeys = mkOption {
                type = types.attrsOf types.str;
                default = { };
              };
              wireguardDevices = mkOption {
                type = types.listOf (
                  types.submodule {
                    options = {
                      publicKey = mkOption { type = types.str; };
                      allowedIPs = mkOption { type = types.listOf types.str; };
                    };
                  }
                );
                default = { };
              };
            };
          }
        );

        default = flake.self.logins.admins;
      };

      robot.sshPubKeys = mkOption {
        description = "SSH Keys to use for the robot user";
        type = types.listOf types.str;
        default = flake.self.logins.robots.sshPubKeys;
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
      ) { } config.pub-solar-os.authentication.users)
      // {
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
      ) { } config.pub-solar-os.authentication.users
    );

    users.groups =
      (lib.attrsets.foldlAttrs (
        acc: name: value:
        acc // { "${name}" = { }; }
      ) { } config.pub-solar-os.authentication.users)
      // {
        ${config.pub-solar-os.authentication.robot.username} = {
          gid = 1100;
        };
      };

    security.sudo.wheelNeedsPassword = false;
  };
}
