# https://registry.terraform.io/providers/namecheap/namecheap/latest/docs
resource "namecheap_domain_records" "pub-solar" {
  domain     = "pub.solar"
  mode       = "OVERWRITE"
  email_type = "MX"

  record {
    hostname = "nachtigall.wg"
    type     = "A"
    address  = "10.7.6.1"
  }
  record {
    hostname = "metronom.wg"
    type     = "A"
    address  = "10.7.6.3"
  }
  record {
    hostname = "tankstelle.wg"
    type     = "A"
    address  = "10.7.6.4"
  }
  record {
    hostname = "trinkgenossin.wg"
    type     = "A"
    address  = "10.7.6.5"
  }
  record {
    hostname = "delite.wg"
    type     = "A"
    address  = "10.7.6.6"
  }
  record {
    hostname = "blue-shell.wg"
    type     = "A"
    address  = "10.7.6.7"
  }
  record {
    hostname = "nachtigall.wg"
    type     = "AAAA"
    address  = "fd00:fae:fae:fae:fae:1::"
  }
  record {
    hostname = "metronom.wg"
    type     = "AAAA"
    address  = "fd00:fae:fae:fae:fae:3::"
  }
  record {
    hostname = "tankstelle.wg"
    type     = "AAAA"
    address  = "fd00:fae:fae:fae:fae:4::"
  }
  record {
    hostname = "trinkgenossin.wg"
    type     = "AAAA"
    address  = "fd00:fae:fae:fae:fae:5::"
  }
  record {
    hostname = "delite.wg"
    type     = "AAAA"
    address  = "fd00:fae:fae:fae:fae:6::"
  }
  record {
    hostname = "blue-shell.wg"
    type     = "AAAA"
    address  = "fd00:fae:fae:fae:fae:7::"
  }
  record {
    hostname = "metronom"
    type     = "A"
    address  = "49.13.236.167"
  }
  record {
    hostname = "mail"
    type     = "A"
    address  = "49.13.236.167"
  }
  record {
    hostname = "trinkgenossin"
    type     = "A"
    address  = "85.215.152.22"
  }
  record {
    hostname = "trinkgenossin"
    type     = "AAAA"
    address  = "2a01:239:35d:f500::1"
  }
  record {
    hostname = "delite"
    type     = "A"
    address  = "5.255.119.132"
  }
  record {
    hostname = "delite"
    type     = "AAAA"
    address  = "2a04:52c0:124:9d8c::2"
  }
  record {
    hostname = "blue-shell"
    type     = "A"
    address  = "194.13.83.205"
  }
  record {
    hostname = "blue-shell"
    type     = "AAAA"
    address  = "2a03:4000:43:24e::1"
  }
  record {
    hostname = "auth"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "mas"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "ci"
    type     = "A"
    address  = "80.71.153.210"
  }
  record {
    hostname = "buckets"
    type     = "A"
    address  = "85.215.152.22"
  }
  record {
    hostname = "buckets"
    type     = "A"
    address  = "5.255.119.132"
  }
  record {
    hostname = "buckets"
    type     = "A"
    address  = "194.13.83.205"
  }
  record {
    hostname = "buckets"
    type     = "AAAA"
    address  = "2a01:239:35d:f500::1"
  }
  record {
    hostname = "buckets"
    type     = "AAAA"
    address  = "2a04:52c0:124:9d8c::2"
  }
  record {
    hostname = "buckets"
    type     = "AAAA"
    address  = "2a03:4000:43:24e::1"
  }
  record {
    hostname = "*.buckets"
    type     = "CNAME"
    address  = "buckets.pub.solar."
  }
  record {
    hostname = "web"
    type     = "CNAME"
    address  = "buckets.pub.solar."
  }
  record {
    hostname = "*.web"
    type     = "CNAME"
    address  = "buckets.pub.solar."
  }
  record {
    hostname = "tankstelle"
    type     = "AAAA"
    address  = "2001:4d88:1ffa:26::5"
  }
  record {
    hostname = "alerts.wg"
    type     = "CNAME"
    address  = "trinkgenossin.wg.pub.solar"
  }
  record {
    hostname = "git"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "rss"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "stream"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "obs-portal"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "vpn"
    type     = "A"
    address  = "80.71.153.210"
  }
  record {
    hostname = "cache"
    type     = "A"
    address  = "95.217.225.160"
  }
  record {
    hostname = "factorio"
    type     = "A"
    address  = "80.244.242.2"
  }
  record {
    hostname = "collabora"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "@"
    type     = "ALIAS"
    address  = "nachtigall.pub.solar."
    ttl      = 300
  }
  record {
    hostname = "chat"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "cloud"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "turn"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "mollysocket"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "grafana"
    type     = "CNAME"
    address  = "trinkgenossin.pub.solar"
  }
  record {
    hostname = "hpb"
    type     = "A"
    address  = "80.71.153.239"
  }
  record {
    hostname = "files"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "search"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "stickers.chat"
    type = "CNAME"
    address = "nachtigall.pub.solar."
  }
  record {
    hostname = "wiki"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "mastodon"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "matrix"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "tmate"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "www"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "@"
    type     = "TXT"
    address  = "v=spf1 a:mail.pub.solar a:list.pub.solar ~all"
  }
  record {
    hostname = "list"
    type     = "TXT"
    address  = "v=spf1 a:list.pub.solar ?all"
  }
  record {
    hostname = "_dmarc"
    type     = "TXT"
    address  = "v=DMARC1; p=reject;"
  }
  record {
    hostname = "_dmarc.list"
    type     = "TXT"
    address  = "v=DMARC1; p=reject;"
  }
  record {
    hostname = "mail._domainkey"
    type     = "TXT"
    address  = "v=DKIM1;k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDI333HhjmVmDYc5hYTtmB6o9KYb782xw+ewH1eQlpFcCMyJ1giYFeGKviNki9uSm52tk34zUIthsqJMRlz2WsKGgk4oq3MRtgPtogxbh1ipJlynXejPU5WVetjjMnwr6AtV1DP1Sv4n5Vz0EV8cTi3tRZdgYpG6hlriiHXbrvlIwIDAQAB"
  }
  record {
    hostname = "@"
    type     = "MX"
    address  = "mail.pub.solar."
    mx_pref  = "0"
  }
  record {
    hostname = "list"
    type     = "MX"
    address  = "list.pub.solar."
    mx_pref  = "0"
  }
  record {
    hostname = "list"
    type     = "A"
    address  = "138.201.80.102"
  }
  record {
    hostname = "list"
    type     = "AAAA"
    address  = "2a01:4f8:172:1c25::1"
  }
  record {
    hostname = "nachtigall"
    type     = "A"
    address  = "138.201.80.102"
  }
  record {
    hostname = "nachtigall"
    type     = "AAAA"
    address  = "2a01:4f8:172:1c25::1"
  }
  record {
    hostname = "underground"
    type     = "A"
    address  = "80.244.242.3"
  }
  record {
    hostname = "test"
    type     = "CNAME"
    address  = "underground.pub.solar."
  }
  record {
    hostname = "mas.test"
    type     = "CNAME"
    address  = "underground.pub.solar."
  }
  record {
    hostname = "matrix.test"
    type     = "CNAME"
    address  = "underground.pub.solar."
  }
  record {
    hostname = "chat.test"
    type     = "CNAME"
    address  = "underground.pub.solar."
  }
  record {
    hostname = "stickers.chat.test"
    type     = "CNAME"
    address  = "underground.pub.solar."
  }
  record {
    hostname = "auth.test"
    type     = "CNAME"
    address  = "underground.pub.solar."
  }
  # SRV records can only be changed via NameCheap Web UI
  # add comment
}
