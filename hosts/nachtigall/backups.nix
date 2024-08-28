{ config, flake, ... }:
{
  age.secrets."restic-repo-droppie" = {
    file = "${flake.self}/secrets/restic-repo-droppie.age";
    mode = "400";
    owner = "root";
  };
  age.secrets."restic-repo-storagebox" = {
    file = "${flake.self}/secrets/restic-repo-storagebox.age";
    mode = "400";
    owner = "root";
  };
  age.secrets.restic-repo-garage-nachtigall = {
    file = "${flake.self}/secrets/restic-repo-garage-nachtigall.age";
    mode = "400";
    owner = "root";
  };
  age.secrets.restic-repo-garage-nachtigall-env = {
    file = "${flake.self}/secrets/restic-repo-garage-nachtigall-env.age";
    mode = "400";
    owner = "root";
  };

  pub-solar-os.backups.repos.storagebox = {
    passwordFile = config.age.secrets."restic-repo-storagebox".path;
    repository = "sftp:u377325@u377325.your-storagebox.de:/backups";
  };

  pub-solar-os.backups.repos.garage = {
    passwordFile = config.age.secrets."restic-repo-garage-nachtigall".path;
    environmentFile = config.age.secrets."restic-repo-garage-nachtigall-env".path;
    repository = "s3:https://buckets.pub.solar/nachtigall-backups";
  };
}
