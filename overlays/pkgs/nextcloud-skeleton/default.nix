# Based on:
# https://nix.dev/tutorials/working-with-local-files.html#union-explicitly-include-files
{
  stdenvNoCC,
  lib,
}:
let
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ./en/Documents/Example.odt
    ./en/Pictures/pubsolar.png
    ./en/Pictures/pubsolar.svg
    ./en/Readme.md
    ./de/Dokumente/Beispiel.odt
    ./de/Fotos/pubsolar.png
    ./de/Fotos/pubsolar.svg
    ./de/Liesmich.md
  ];
in

fs.trace sourceFiles

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
