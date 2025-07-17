{
  writeShellApplication,
  coreutils,
  curl,
  forgejo,
  jq,
  keycloak,
  openssl,
  sudo,
}:
writeShellApplication {
  name = "delete-pubsolar-id";
  text = ''
    set -e
    PATH=$PATH:${coreutils}/bin:${curl}/bin:${forgejo}/bin:${jq}/bin:${keycloak}/bin:${openssl}/bin:${sudo}/bin

    KEYCLOAK_SECRET=$1
    MATRIX_ADMIN_ACCESS_TOKEN=$2
    USERNAME=$3

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

    sudo -u mastodon mastodon-tootctl accounts delete --email "$USER_EMAIL" || true

    ### Matrix ###

    echo "Deleting matrix account"
    curl --header "Authorization: Bearer $MATRIX_ADMIN_ACCESS_TOKEN" --request POST "http://127.0.200.10:8008/_synapse/admin/v1/deactivate/@$USERNAME:pub.solar" --data '{"erase": true}' || true

    ### Forgejo ###

    echo "Deleting forgejo data"
    sudo -u gitea gitea admin user delete --config /var/lib/forgejo/custom/conf/app.ini --purge --email "$USER_EMAIL" || true
  '';
}
