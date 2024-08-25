{
  flake,
  config,
  lib,
  pkgs,
  ...
}: let
  utils = import "${flake.inputs.nixpkgs}/nixos/lib/utils.nix" { inherit lib; inherit config; inherit pkgs; };
  # Type for a valid systemd unit option. Needed for correctly passing "timerConfig" to "systemd.timers"
  inherit (utils.systemdUtils.unitOptions) unitOption;
in {
  options.pub-solar-os.backups = {
    stores =
      with lib;
      mkOption {
        description = ''
          Periodic backups to create with Restic.
        '';
        type = types.attrsOf (
          types.submodule (
            { name, ... }:
            {
              options = {
                passwordFile = mkOption {
                  type = types.str;
                  description = ''
                    Read the repository password from a file.
                  '';
                  example = "/etc/nixos/restic-password";
                };

                repository = mkOption {
                  type = with types; nullOr str;
                  default = null;
                  description = ''
                    repository to backup to.
                  '';
                  example = "sftp:backup@192.168.1.100:/backups/${name}";
                };
              };
            }
          )
        );

        default = { };
        example = {
          remotebackup = {
            repository = "sftp:backup@host:/backups/home";
            passwordFile = "/etc/nixos/secrets/restic-password";
          };
        };
      };

    backups =
      with lib;
      mkOption {
        description = ''
          Periodic backups to create with Restic.
        '';
        type = types.attrsOf (
          types.submodule (
            { name, ... }:
            {
              options = {
                paths = mkOption {
                  # This is nullable for legacy reasons only. We should consider making it a pure listOf
                  # after some time has passed since this comment was added.
                  type = types.nullOr (types.listOf types.str);
                  default = [ ];
                  description = ''
                    Which paths to backup, in addition to ones specified via
                    `dynamicFilesFrom`.  If null or an empty array and
                    `dynamicFilesFrom` is also null, no backup command will be run.
                     This can be used to create a prune-only job.
                  '';
                  example = [
                    "/var/lib/postgresql"
                    "/home/user/backup"
                  ];
                };

                exclude = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = ''
                    Patterns to exclude when backing up. See
                    https://restic.readthedocs.io/en/latest/040_backup.html#excluding-files for
                    details on syntax.
                  '';
                  example = [
                    "/var/cache"
                    "/home/*/.cache"
                    ".git"
                  ];
                };

                timerConfig = mkOption {
                  type = types.nullOr (types.attrsOf unitOption);
                  default = {
                    OnCalendar = "daily";
                    Persistent = true;
                  };
                  description = ''
                    When to run the backup. See {manpage}`systemd.timer(5)` for
                    details. If null no timer is created and the backup will only
                    run when explicitly started.
                  '';
                  example = {
                    OnCalendar = "00:05";
                    RandomizedDelaySec = "5h";
                    Persistent = true;
                  };
                };

                user = mkOption {
                  type = types.str;
                  default = "root";
                  description = ''
                    As which user the backup should run.
                  '';
                  example = "postgresql";
                };

                extraBackupArgs = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = ''
                    Extra arguments passed to restic backup.
                  '';
                  example = [ "--exclude-file=/etc/nixos/restic-ignore" ];
                };

                extraOptions = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = ''
                    Extra extended options to be passed to the restic --option flag.
                  '';
                  example = [ "sftp.command='ssh backup@192.168.1.100 -i /home/user/.ssh/id_rsa -s sftp'" ];
                };

                initialize = mkOption {
                  type = types.bool;
                  default = false;
                  description = ''
                    Create the repository if it doesn't exist.
                  '';
                };

                pruneOpts = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = ''
                    A list of options (--keep-\* et al.) for 'restic forget
                    --prune', to automatically prune old snapshots.  The
                    'forget' command is run *after* the 'backup' command, so
                    keep that in mind when constructing the --keep-\* options.
                  '';
                  example = [
                    "--keep-daily 7"
                    "--keep-weekly 5"
                    "--keep-monthly 12"
                    "--keep-yearly 75"
                  ];
                };

                runCheck = mkOption {
                  type = types.bool;
                  default = (builtins.length config.pub-solar-os.backups.backups.${name}.checkOpts > 0);
                  defaultText = literalExpression ''builtins.length config.services.backups.${name}.checkOpts > 0'';
                  description = "Whether to run the `check` command with the provided `checkOpts` options.";
                  example = true;
                };

                checkOpts = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = ''
                    A list of options for 'restic check'.
                  '';
                  example = [ "--with-cache" ];
                };

                dynamicFilesFrom = mkOption {
                  type = with types; nullOr str;
                  default = null;
                  description = ''
                    A script that produces a list of files to back up.  The
                    results of this command are given to the '--files-from'
                    option. The result is merged with paths specified via `paths`.
                  '';
                  example = "find /home/matt/git -type d -name .git";
                };

                backupPrepareCommand = mkOption {
                  type = with types; nullOr str;
                  default = null;
                  description = ''
                    A script that must run before starting the backup process.
                  '';
                };

                backupCleanupCommand = mkOption {
                  type = with types; nullOr str;
                  default = null;
                  description = ''
                    A script that must run after finishing the backup process.
                  '';
                };

                package = mkPackageOption pkgs "restic" { };

                createWrapper = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = ''
                    Whether to generate and add a script to the system path, that has the same environment variables set
                    as the systemd service. This can be used to e.g. mount snapshots or perform other opterations, without
                    having to manually specify most options.
                  '';
                };
              };
            }
          )
        );
        default = { };
        example = {
          localbackup = {
            paths = [ "/home" ];
            exclude = [ "/home/*/.cache" ];
            initialize = true;
          };
          remotebackup = {
            paths = [ "/home" ];
            extraOptions = [
              "sftp.command='ssh backup@host -i /etc/nixos/secrets/backup-private-key -s sftp'"
            ];
            timerConfig = {
              OnCalendar = "00:05";
              RandomizedDelaySec = "5h";
            };
          };
        };
      };
  };

  config = {
    services.restic.backups =
      let
        stores = config.pub-solar-os.backups.stores;
        backups = config.pub-solar-os.backups.backups;

        storeNames = builtins.attrNames stores;
        backupNames = builtins.attrNames backups;

        createBackups =
          backupName:
          map (storeName: {
            name = "${backupName}-${storeName}";
            value = stores."${storeName}" // backups."${backupName}";
          }) storeNames;

      in
      builtins.listToAttrs (lib.lists.flatten (map createBackups backupNames));
  };
}
