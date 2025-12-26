{
  writeShellApplication,
  coreutils,
  curl,
  forgejo-lts,
  jq,
  keycloak,
  matrix-authentication-service,
  openssl,
  sudo,
}:
# writeShellApplication uses:
# set -o errexit
# set -o nounset
# set -o pipefail
writeShellApplication {
  name = "delete-pubsolar-id";
  text = ''
    PATH=$PATH:${coreutils}/bin:${curl}/bin:${forgejo-lts}/bin:${jq}/bin:${keycloak}/bin:${matrix-authentication-service}/bin:${openssl}/bin:${sudo}/bin

    function fatal {
      local msg="$*"
      [[ -z "$msg" ]] && msg="failed"
      echo "$msg" >&2
      exit 1
    }

    set +u

    KEYCLOAK_SECRET=$1
    MATRIX_ADMIN_ACCESS_TOKEN=$2
    MAS_CONFIG_PATH=$3
    USERNAME=$4

    set -u

    [[ -z "$KEYCLOAK_SECRET" ]] && fatal "missing first argument keycloak secret"
    [[ -z "$MATRIX_ADMIN_ACCESS_TOKEN" ]] && fatal "missing second argument matrix admin access token"
    [[ -z "$MAS_CONFIG_PATH" ]] && fatal "missing third argument mas config path"
    [[ -z "$USERNAME" ]] && fatal "missing fourth argument username"

    DIR=$(mktemp -d)

    cd "$DIR"

    sudo --user keycloak kcadm.sh config credentials --config /tmp/kcadm.config --server http://localhost:8080 --realm pub.solar --client admin-cli --secret "$KEYCLOAK_SECRET"

    # Take note of user id in response from following command
    USER_DATA=$(sudo --user keycloak kcadm.sh get --config /tmp/kcadm.config users --realm pub.solar --query "username=$USERNAME")
    USER_ID=$(echo "$USER_DATA" | jq .[].id -r )
    USER_EMAIL=$(echo "$USER_DATA" | jq .[].email -r )

    echo "Deleting the following user:"
    echo "username: $USERNAME"
    echo "user id: $USER_ID"
    echo "user email: $USER_EMAIL"

    # To avoid impersonification, we deactivate the account by resetting the password and email address
    # Use user id from previous command, for example
    sudo --user keycloak kcadm.sh update --config /tmp/kcadm.config "users/$USER_ID/reset-password" --realm pub.solar --set type=password --set value="$(openssl rand -hex 32)" --no-merge
    sudo --user keycloak kcadm.sh update --config /tmp/kcadm.config "users/$USER_ID" --realm pub.solar --set "email=$USERNAME@deactivated.pub.solar"

    ### Nextcloud ###

    echo "Deleting nextcloud data"
    sudo nextcloud-occ user:delete "$USERNAME"

    ### Mastodon ###

    echo "Deleting mastodon data"
    sudo chown mastodon "$DIR"

    sudo -u mastodon mastodon-tootctl accounts delete "$USERNAME" || true

    ### Matrix ###

    echo "Deleting matrix account"
    curl --header "Authorization: Bearer $MATRIX_ADMIN_ACCESS_TOKEN" --request POST "http://127.0.200.10:8008/_synapse/admin/v1/deactivate/@$USERNAME:pub.solar" --data '{"erase": true}' || true
    sudo -u matrix-authentication-service mas-cli --config "$MAS_CONFIG_PATH" --config /run/agenix/matrix-authentication-service-secret-config.yml manage kill-sessions "$USERNAME" || true

    ### Forgejo ###

    echo "Deleting forgejo data"
    sudo -u gitea forgejo admin user delete --config /var/lib/forgejo/custom/conf/app.ini --purge --username "$USERNAME" || true
  '';
}
