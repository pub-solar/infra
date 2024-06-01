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
    hostname = "flora-6.wg"
    type     = "A"
    address  = "10.7.6.2"
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
    hostname = "nachtigall.wg"
    type     = "AAAA"
    address  = "fd00:fae:fae:fae:fae:1::"
  }
  record {
    hostname = "flora-6.wg"
    type     = "AAAA"
    address  = "fd00:fae:fae:fae:fae:2::"
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
    hostname = "flora-6"
    type     = "A"
    address  = "80.71.153.210"
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
    hostname = "auth"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "ci"
    type     = "A"
    address  = "80.71.153.210"
  }
  record {
    hostname = "tankstelle"
    type     = "A"
    address  = "80.244.242.5"
  }
  record {
    hostname = "alerts"
    type     = "A"
    address  = "10.7.6.2"
  }
  record {
    hostname = "git"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "stream"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "list"
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
    hostname = "grafana"
    type     = "A"
    address  = "80.71.153.210"
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
    hostname = "modoboa._domainkey"
    type     = "TXT"
    address  = "v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx/EqLMpk0MyL1aQ0JVG44ypTRbZBVA13MFjEntxAvowaWtq1smRbnEwTTKgqUOrUyaM4dVmli1dedne4mk/ncqRAm02KuhtTY+5wXfhTKK53EhqehbKwH+Qvzb12983Qwdau/QTHiFHwXHufMaSsCvd9CRWCp9q68Q7noQqndJeLHT6L0eECd2Zk3ZxJuh+Fxdb7+Kw68Tf6z13Rs+MU01qLM7x0jmSQHa4cv2pk+7NTGMBRp6fVskfbqev5nFkZWJ7rhXEbP9Eukd/L3ro/ubs1quWJotG02gPRKE8fgkm1Ytlws1/pnqpuvKXQS1HzBEP1X2ExezJMzQ1SnZCigQIDAQAB"
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
    hostname = "matrix.test"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  # SRV records can only be changed via NameCheap Web UI
  # add comment
}
