# https://registry.terraform.io/providers/namecheap/namecheap/latest/docs
resource "namecheap_domain_records" "pub-solar" {
  domain = "pub.solar"
  mode = "OVERWRITE"
  email_type = "MX"

  record {
    hostname = "flora-6"
    type = "A"
    address = "80.71.153.210"
    ttl = 60
  }
  record {
    hostname = "auth"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "ci"
    type = "A"
    address = "80.71.153.210"
    ttl = 60
  }
  record {
    hostname = "git"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "stream"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "list"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "obs-portal"
    type = "A"
    address = "80.71.153.210"
    ttl = 60
  }
  record {
    hostname = "vpn"
    type = "A"
    address = "80.71.153.210"
    ttl = 60
  }
  record {
    hostname = "cache"
    type = "A"
    address = "95.217.225.160"
    ttl = 60
  }
  record {
    hostname = "factorio"
    type = "A"
    address = "80.244.242.2"
    ttl = 60
  }
  record {
    hostname = "collabora"
    type = "CNAME"
    address = "nachtigall.pub.solar."
    ttl = 60
  }
  record {
    hostname = "libreddit"
    type = "CNAME"
    address = "nachtigall.pub.solar."
    ttl = 60
  }
  record {
    hostname = "@"
    type = "ALIAS"
    address = "nachtigall.pub.solar."
    ttl = 300
  }
  record {
    hostname = "chat"
    type = "A"
    address = "85.88.23.162"
    ttl = 60
  }
  record {
    hostname = "cloud"
    type = "CNAME"
    address = "nachtigall.pub.solar."
    ttl = 60
  }
  record {
    hostname = "coturn"
    type = "A"
    address = "80.71.153.239"
    ttl = 60
  }
  record {
    hostname = "hpb"
    type = "A"
    address = "80.71.153.239"
    ttl = 60
  }
  record {
    hostname = "dimension"
    type = "A"
    address = "85.88.23.162"
    ttl = 60
  }
  record {
    hostname = "element"
    type = "A"
    address = "85.88.23.162"
    ttl = 60
  }
  record {
    hostname = "files"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "search"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "mastodon"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "matrix"
    type = "A"
    address = "85.88.23.162"
    ttl = 60
  }
  record {
    hostname = "www"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "@"
    type = "TXT"
    address = "v=spf1 include:spf.greenbaum.cloud a:list.pub.solar ~all"
  }
  record {
    hostname = "list"
    type = "TXT"
    address = "v=spf1 a:list.pub.solar ?all"
  }
  record {
    hostname = "_dmarc"
    type = "TXT"
    address = "v=DMARC1; p=reject;"
  }
  record {
    hostname = "_dmarc.list"
    type = "TXT"
    address = "v=DMARC1; p=reject;"
  }
  record {
    hostname = "@"
    type = "MX"
    address = "mx2.greenbaum.cloud."
    mx_pref = "0"
  }
  record {
    hostname = "list"
    type = "MX"
    address = "list.pub.solar."
    mx_pref = "0"
  }
  record {
    hostname = "nachtigall"
    type = "A"
    address = "138.201.80.102"
  }
  record {
    hostname = "nachtigall"
    type = "AAAA"
    address = "2a01:4f8:172:1c25::1"
  }
  record {
    hostname = "matrix.test"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "chat.test"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "test"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  # SRV records can only be changed via NameCheap Web UI
  # add comment
}
