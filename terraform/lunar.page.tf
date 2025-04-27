# https://registry.terraform.io/providers/namecheap/namecheap/latest/docs
resource "namecheap_domain_records" "lunar-page" {
  domain     = "lunar.page"
  mode       = "OVERWRITE"
  email_type = "MX"

  record {
    hostname = "@"
    type     = "A"
    address  = "85.215.152.22"
    ttl      = 60
  }
  record {
    hostname = "@"
    type     = "AAAA"
    address  = "2a01:239:35d:f500::1"
    ttl      = 60
  }
  record {
    hostname = "*"
    type     = "CNAME"
    address  = "lunar.page"
    ttl      = 60
  }

  record {
    hostname = "@"
    type     = "MX"
    address  = "eforward1.registrar-servers.com."
    ttl      = 60
  }

  record {
    hostname = "@"
    type     = "MX"
    address  = "eforward2.registrar-servers.com."
    ttl      = 60
  }

  record {
    hostname = "@"
    type     = "MX"
    address  = "eforward3.registrar-servers.com."
    ttl      = 60
  }

  record {
    hostname = "@"
    type     = "MX"
    address  = "eforward4.registrar-servers.com."
    ttl      = 60
  }

  record {
    hostname = "@"
    type     = "MX"
    address  = "eforward5.registrar-servers.com."
    ttl      = 60
  }
}
