final: prev: {
  matrix-synapse-unwrapped = prev.matrix-synapse-unwrapped.overrideAttrs (oldAttrs: rec {
    inherit (oldAttrs) pname;
    version = "1.138.3";
    src = prev.fetchFromGitHub {
      owner = "element-hq";
      repo = "synapse";
      rev = "v${version}";
      hash = "sha256-16ylHGrLhH5VPVPuOn++PSARuqzDSv2y031pZnj7KJQ=";
    };

    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      name = "${pname}-${version}";
      hash = "sha256-aUZUg8+1UlDzsxJN87Bk/DjD5WFcvHGVBRf1rIXKOZ4=";
    };
  });
}
