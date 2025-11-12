{ config, flake, ... }:
{
  age.secrets."restic-repo-droppie-metronom" = {
    file = "${flake.self}/secrets/restic-repo-droppie-metronom.age";
    mode = "400";
    owner = "root";
  };
  age.secrets."restic-repo-storagebox-metronom" = {
    file = "${flake.self}/secrets/restic-repo-storagebox-metronom.age";
    mode = "400";
    owner = "root";
  };
  age.secrets.restic-repo-garage-metronom = {
    file = "${flake.self}/secrets/restic-repo-garage-metronom.age";
    mode = "400";
    owner = "root";
  };
  age.secrets.restic-repo-garage-metronom-env = {
    file = "${flake.self}/secrets/restic-repo-garage-metronom-env.age";
    mode = "400";
    owner = "root";
  };

  pub-solar-os.backups.repos.droppie = {
    passwordFile = config.age.secrets."restic-repo-droppie-metronom".path;
    repository = "sftp:hakkonaut@droppie.wg.pub.solar:/var/lib/pub-solar-backups/metronom";
  };

  pub-solar-os.backups.repos.storagebox = {
    passwordFile = config.age.secrets."restic-repo-storagebox-metronom".path;
    repository = "sftp:u377325@u377325.your-storagebox.de:/metronom-backups";
  };

  pub-solar-os.backups.repos.garage = {
    passwordFile = config.age.secrets."restic-repo-garage-metronom".path;
    environmentFile = config.age.secrets."restic-repo-garage-metronom-env".path;
    repository = "s3:https://buckets.pub.solar/metronom-backups";
  };
}
