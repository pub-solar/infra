final: prev: {
  matrix-synapse-unwrapped = prev.matrix-synapse-unwrapped.overrideAttrs (oldAttrs: rec {
    inherit (oldAttrs) pname;
    version = "1.127.1";
    src = prev.fetchFromGitHub {
      owner = "element-hq";
      repo = "synapse";
      rev = "v${version}";
      hash = "sha256-DNUKbb+d3BBp8guas6apQ4yFeXCc0Ilijtbt1hZkap4=";
    };

    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      name = "${pname}-${version}";
      hash = "sha256-wI3vOfR5UpVFls2wPfgeIEj2+bmWdL3pDSsKfT+ysw8=";
    };
  });
}
