# https://registry.terraform.io/providers/namecheap/namecheap/latest/docs
resource "namecheap_domain_records" "pub-solar" {
  domain     = "pub.solar"
  mode       = "OVERWRITE"
  email_type = "MX"

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
    address  = "v=spf1 include:spf.greenbaum.zone a:list.pub.solar ~all"
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
    hostname = "modoboa._domainkey"
    type     = "TXT"
    address  = "v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx/EqLMpk0MyL1aQ0JVG44ypTRbZBVA13MFjEntxAvowaWtq1smRbnEwTTKgqUOrUyaM4dVmli1dedne4mk/ncqRAm02KuhtTY+5wXfhTKK53EhqehbKwH+Qvzb12983Qwdau/QTHiFHwXHufMaSsCvd9CRWCp9q68Q7noQqndJeLHT6L0eECd2Zk3ZxJuh+Fxdb7+Kw68Tf6z13Rs+MU01qLM7x0jmSQHa4cv2pk+7NTGMBRp6fVskfbqev5nFkZWJ7rhXEbP9Eukd/L3ro/ubs1quWJotG02gPRKE8fgkm1Ytlws1/pnqpuvKXQS1HzBEP1X2ExezJMzQ1SnZCigQIDAQAB"
  }
  record {
    hostname = "@"
    type     = "MX"
    address  = "mail.greenbaum.zone."
    mx_pref  = "0"
  }
  record {
    hostname = "list"
    type     = "MX"
    address  = "list.pub.solar."
    mx_pref  = "0"
  }
  record {
    hostname = "metronom"
    type     = "TXT"
    address  = "v=spf1 a:metronom.pub.solar ?all"
  }
  record {
    hostname = "mail._domainkey.metronom"
    type     = "TXT"
    address  = "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCpFkI+IqTwyUIo5LqYVPMXlkTJe7trcE+ln6vjLFcoXBZaXfFVRJThMtfEZLkJ84ndEHadszFdSZs8eLRVCt/h7x9+GaOPIdKI9lbOn+AepwxhE3z/VrKKfO0CFyLsA6+XY7ebiF1aYctalY+r8Jtt8LuXh0Fj6+4YAFkvNxJEnQIDAQAB"
  }
  record {
    hostname = "_dmarc.metronom"
    type     = "TXT"
    address  = "v=DMARC1; p=reject;"
  }
  record {
    hostname = "metronom"
    type     = "MX"
    address  = "metronom.pub.solar."
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
