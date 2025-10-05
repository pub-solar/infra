{ writeShellScriptBin, curl }:
writeShellScriptBin "puppeteer-run" ''
  set -e

  exec ${curl}/bin/curl --fail-with-body -X POST -d "$@" -s --unix-socket "/tmp/puppeteer.sock" http://puppeteer-socket
''
