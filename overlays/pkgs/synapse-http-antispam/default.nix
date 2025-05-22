{
  lib,
  python3,
  fetchFromGitHub,
  matrix-synapse-unwrapped,
  nix-update-script,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "synapse-http-antispam";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "synapse-http-antispam";
    tag = "v${version}";
    hash = "sha256-YvgHIZ5Kr9WsX30QN8W5OJ4sxLB7EsLqUmCye3x+JQA=";
  };

  build-system = [ python3.pkgs.hatchling ];

  pythonImportsCheck = [ "synapse_http_antispam" ];

  prePatch = ''
    # pythonRelaxDeps doesn't work here
    substituteInPlace pyproject.toml --replace-fail 'license-files = ["LICENSE"]' 'license-files = { paths = ["LICENSE"] }'
  '';

  buildInputs = [ matrix-synapse-unwrapped ];
  dependencies = [ python3.pkgs.twisted ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Synapse module that forwards spam checking to an HTTP server";
    homepage = "https://github.com/maunium/synapse-http-antispam";
    changelog = "https://github.com/maunium/synapse-http-antispam/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sumnerevans ];
  };
}
