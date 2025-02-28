# Based on:
# https://nix.dev/tutorials/working-with-local-files.html#union-explicitly-include-files
{
  stdenvNoCC,
  lib,
}:
let
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ./default/Documents/Example.odt
    ./default/Pictures/pubsolar.png
    ./default/Pictures/pubsolar.svg
    ./default/Readme.md
    ./de/Dokumente/Beispiel.odt
    ./de/Fotos/pubsolar.png
    ./de/Fotos/pubsolar.svg
    ./de/Liesmich.md
  ];
in
  stdenvNoCC.mkDerivation
  {
    name = "nextcloud-skeleton";
    src = fs.toSource {
      root = ./.;
      fileset = sourceFiles;
    };
    postInstall = ''
      cp -vr . $out
    '';
  }
