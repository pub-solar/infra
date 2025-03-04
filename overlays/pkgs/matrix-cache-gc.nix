{
  inputs,
  writeShellApplication,
}:
writeShellApplication {
  name = "matrix-cache-gc";
  text = ''
## CONFIGURATION ##
#AWS_ACCESS_KEY_ID=GKxxx
#AWS_SECRET_ACCESS_KEY=xxxx
AWS_ENDPOINT_URL=https://buckets.pub.solar
S3_BUCKET=matrix-synapse
MEDIA_STORE=/var/lib/matrix-synapse/media_store
PG_USER=matrix-synapse
PG_DB=matrix
PG_HOST=/run/postgresql

## CODE ##
cat > database.yaml <<EOF
user: $PG_USER
database: $PG_DB
host: $PG_HOST
EOF

alias s3_media_upload=${inputs.nixpkgs.legacyPackages.x86_64-linux.matrix-synapse.plugins.matrix-synapse-s3-storage-provider}/bin/s3_media_upload
s3_media_upload update-db 1d
s3_media_upload --no-progress check-deleted "$MEDIA_STORE"
s3_media_upload --no-progress upload "$MEDIA_STORE" "$S3_BUCKET" --delete --endpoint-url "$AWS_ENDPOINT_URL"
'';
}
