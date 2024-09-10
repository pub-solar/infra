# Changing DNS entries

Our current DNS provider is [namecheap](https://www.namecheap.com/).
We use [OpenTofu](https://opentofu.org) to declaratively manage our pub.solar DNS records.

### Initial setup

You will need to setup the following [namecheap API credentials](https://www.namecheap.com/support/api/intro),
look for "namecheap API key" in the pub.solar Keepass database.

```
NAMECHEAP_API_KEY
NAMECHEAP_API_USER
NAMECHEAP_USER_NAME
```

You will probably also need to add your external IP to the [API allow list](https://ap.www.namecheap.com/settings/tools/apiaccess/whitelisted-ips).

```
dig -4 ip @dns.toys
```

Now, change into the terraform directory and initialize the terraform providers. To decrypt existing state,
search for "terraform state passphrase" in the pub.solar Keepass database.

```
cd terraform
export TF_VAR_state_passphrase=$(secret-tool lookup pub.solar terraform-state-passphrase-dns)

alias tofu="terraform-backend-git --access-logs --tf tofu git terraform"
tofu init
```

Make your changes, e.g. in `dns.tf`.

```
$EDITOR dns.tf
```

Plan your changes using:

```
tofu plan -out pub-solar-infra.plan
```

After verification, apply your changes with:

```
tofu apply "pub-solar-infra.plan"
```

### Useful links

We use terraform-backend-git remote backend with opentofu state encryption for collaboration.

- https://github.com/plumber-cd/terraform-backend-git
- https://opentofu.org/docs/language/state/encryption

Namecheap Terraform provider docs:

- https://registry.terraform.io/providers/namecheap/namecheap/latest/docs
