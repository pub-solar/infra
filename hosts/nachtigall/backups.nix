{ flake, ... }: {
  age.secrets."restic-repo-droppie" = {
    file = "${flake.self}/secrets/restic-repo-droppie.age";
    mode = "400";
    owner = "root";
  };
}
