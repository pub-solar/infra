# Changing DNS entries

### Initial setup

Change into the terraform directory and initialize the terraform providers.

```
cd terraform
cat ~/.config/triton/profiles.d/lev-1-pub_solar.json | grep keyId
export TRITON_KEY_ID=

terraform init
```

Plan your changes using:
```
terraform plan -out pub-solar-infra.plan
```

After verification, apply your changes with:
```
terraform apply "pub-solar-infra.plan"
```
