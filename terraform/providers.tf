terraform {
  required_version = "~> 1.2.3"
  required_providers {
    namecheap = {
      source = "namecheap/namecheap"
      version = "2.1.0"
    }
  }
}

provider "namecheap" {
  # Configuration options
}
