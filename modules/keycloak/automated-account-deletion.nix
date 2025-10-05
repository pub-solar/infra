{
  writeShellScriptBin,
  keycloak,
  jq,
}:
writeShellScriptBin "autodelete-accounts" ''
  set -e

  USERS=$(${keycloak}/bin/kcadm.sh get users -r test.pub.solar --server http://localhost:8080 --realm master --user admin --password password --no-config")
''
