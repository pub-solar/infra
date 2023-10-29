# https://www.terraform.io/language/v1.2.x/settings/backends/manta
terraform {
  backend "manta" {
    path        = "pub-solar/nachtigall"
    object_name = "terraform.tfstate"
  }
}
