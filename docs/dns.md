# Changing DNS entries

Our current DNS provider is [namecheap](https://www.namecheap.com/).
We use [Terraform](https://www.terraform.io) to declaratively manage our pub.solar DNS records.

### Initial setup

Skip this step if you already have a `triton` profile setup.

```
triton profile create
```

Please follow https://docs.greenbaum.cloud/en/devops/triton-cli.html for the details.

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

Now, change into the terraform directory and initialize the terraform providers.

```
cd terraform
export TRITON_KEY_ID=$(cat ~/.config/triton/profiles.d/lev-1-pub_solar.json | jq --raw-output .keyId)

terraform init
```

Make your changes, e.g. in `dns.tf`.

```
$EDITOR dns.tf
```

Plan your changes using:

```
terraform plan -out pub-solar-infra.plan
```

After verification, apply your changes with:

```
terraform apply "pub-solar-infra.plan"
```

### Useful links

We use the Manta remote backend to save the terraform state for collaboration.

- https://www.terraform.io/language/v1.2.x/settings/backends/manta

Namecheap Terraform provider docs:

- https://registry.terraform.io/providers/namecheap/namecheap/latest/docs
