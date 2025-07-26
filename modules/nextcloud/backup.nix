{
  config,
  pkgs,
  flake,
  lib,
  ...
}:
{
  services.restic.backups.nextcloud-storagebox = {
    paths = [
      "/var/lib/nextcloud/data"
      "/tmp/nextcloud-backup.sql"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00 Etc/UTC";
    };
    initialize = true;
    passwordFile = config.age.secrets."restic-repo-storagebox-nachtigall".path;
    repository = "sftp:u377325@u377325.your-storagebox.de:/backups";
    backupPrepareCommand = ''
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d nextcloud > /tmp/nextcloud-backup.sql
    '';
    backupCleanupCommand = ''
      rm /tmp/nextcloud-backup.sql
    '';
  };
}
