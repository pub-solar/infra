# Updating mediawiki docker container

See the [mediawiki-oidc-docker repository](https://git.pub.solar/pub-solar/mediawiki-oidc-docker#updating-the-docker-image)
for instructions on updating our customized mediawiki docker image.

To deploy a new docker image to `nachtigall`, first bump the mediawiki version
of the docker image tag in `hosts/nachtigall/apps/mediawiki.nix` (search for
`image`).

Next, push your changes to https://git.pub.solar and get them reviewed and
approved.

After approval, create a fresh backup of the database and deploy the changes to
`nachtigall`:

```
ssh barkeeper@nachtigall.pub.solar
sudo -u postgres pg_dump --create -Fc mediawiki > mediawiki-db-$(date +%F).dump
exit
```

```
deploy --targets '.#nachtigall'
```

Then, finalize the update by running the database migration script:
```
ssh barkeeper@nachtigall.pub.solar
docker exec -it mediawiki bash
php maintenance/run.php update.php
```
