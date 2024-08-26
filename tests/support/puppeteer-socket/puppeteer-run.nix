{
  writeShellScriptBin,
  curl
}: writeShellScriptBin "puppeteer-run" ''
set -e

exec ${curl}/bin/curl -X POST -d "$@" --unix-socket "/tmp/puppeteer.sock" http://puppeteer-socket
''
