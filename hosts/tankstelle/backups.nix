{ flake, ... }:
{
  age.secrets."restic-repo-droppie" = {
    file = "${flake.self}/secrets/restic-repo-droppie.age";
    mode = "400";
    owner = "root";
  };
  age.secrets."restic-repo-storagebox-tankstelle" = {
    file = "${flake.self}/secrets/restic-repo-storagebox-tankstelle.age";
    mode = "400";
    owner = "root";
  };
}
