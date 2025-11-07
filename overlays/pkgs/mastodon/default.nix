{
  lib,
  stdenvNoCC,
  mastodon,
  themes,
  inputs,
}:
let
  copyPaths =
    paths: lib.concatStringsSep "\n" (lib.map (path: "cp -r ${path} app/javascript/styles/") paths);

  addThemes = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: theme: ''
      ${copyPaths theme.paths}
      echo "${name}: styles/${theme.entrypoint}" >> config/themes.yml
    '') themes
  );
  src = stdenvNoCC.mkDerivation {
    name = "mastodon-with-extra-themes";
    src = mastodon.src;
    phases = [
      "unpackPhase"
      "installPhase"
    ];
    installPhase = ''
      cp -r . $out
      cd $out
      ${addThemes}
      cp ${inputs.tangerine-ui}/mastodon/config/locales/tangerineui.yml config/locales/
    '';
  };
in
mastodon.overrideAttrs (oldAttrs: {
  inherit src;
  mastodonModules = oldAttrs.mastodonModules.overrideAttrs (_: {
    inherit src;
  });
})
