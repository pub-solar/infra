terraform {
  required_version = "~> 1.10.0"
  required_providers {
    namecheap = {
      source  = "namecheap/namecheap"
      version = "2.2.0"
    }
    hostingde = {
      source  = "registry.terraform.io/pub-solar/hostingde"
      version = ">= 0.0.1"
    }
  }
}

provider "namecheap" {
  # Configuration options
}

# Not recommended, use environment variables to configure the provider
# See: https://github.com/pub-solar/terraform-provider-hostingde
# HOSTINGDE_AUTH_TOKEN (required)
# HOSTINGDE_ACCOUNT_ID (optional)
#provider "hostingde" {
#  auth_token = "YOUR_API_TOKEN"
#  account_id = "YOUR_ACCOUNT_ID"
#}
