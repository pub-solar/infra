{ flake, ... }: {
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
}
