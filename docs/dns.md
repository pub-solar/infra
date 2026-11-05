# Changing DNS entries

Our current DNS provider is [hosting.de](https://www.hosting.de/).
We use [OpenTofu](https://opentofu.org) to declaratively manage our pub.solar DNS records.

### Initial setup

You will need to setup the following [hosting.de API credentials](https://secure.hosting.de/profile),
look for "hosting.de API token" in the pub.solar Keepass database.

```
HOSTINGDE_API_KEY
```

You will probably also need to add your external IP to the API key allow list.

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

Hosting.de Terraform provider docs:

- https://registry.terraform.io/providers/pub-solar/hostingde/latest/docs
