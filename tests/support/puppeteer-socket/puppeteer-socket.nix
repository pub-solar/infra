{
  buildNpmPackage,
  nodejs,
}:
buildNpmPackage rec {
  src = ./.;
  name = "puppeteer-socket";
  nativeBuildInputs = [ nodejs ];
  npmDepsHash = "sha256-d+mbHdwt9V5JIBUw/2NyTMBlZ3D5UNE8TpVXJm8rcnU=";
  dontNpmBuild = true;
}
