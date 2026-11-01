resource "hostingde_zone" "pub-solar" {
  name = "pub.solar"
  type = "NATIVE"
}

resource "hostingde_record" "nachtigall-wg-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "nachtigall.wg.pub.solar"
  type    = "A"
  content = "10.7.6.1"
}

resource "hostingde_record" "metronom-wg-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "metronom.wg.pub.solar"
  type    = "A"
  content = "10.7.6.3"
}

resource "hostingde_record" "tankstelle-wg-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "tankstelle.wg.pub.solar"
  type    = "A"
  content = "10.7.6.4"
}

resource "hostingde_record" "trinkgenossin-wg-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "trinkgenossin.wg.pub.solar"
  type    = "A"
  content = "10.7.6.5"
}

resource "hostingde_record" "delite-wg-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "delite.wg.pub.solar"
  type    = "A"
  content = "10.7.6.6"
}

resource "hostingde_record" "blue-shell-wg-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "blue-shell.wg.pub.solar"
  type    = "A"
  content = "10.7.6.7"
}

resource "hostingde_record" "limes-wg-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "limes.wg.pub.solar"
  type    = "A"
  content = "10.7.6.8"
}

resource "hostingde_record" "nachtigall-wg-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "nachtigall.wg.pub.solar"
  type    = "AAAA"
  content = "fd00:fae:fae:fae:fae:1::"
}

resource "hostingde_record" "metronom-wg-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "metronom.wg.pub.solar"
  type    = "AAAA"
  content = "fd00:fae:fae:fae:fae:3::"
}

resource "hostingde_record" "tankstelle-wg-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "tankstelle.wg.pub.solar"
  type    = "AAAA"
  content = "fd00:fae:fae:fae:fae:4::"
}

resource "hostingde_record" "trinkgenossin-wg-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "trinkgenossin.wg.pub.solar"
  type    = "AAAA"
  content = "fd00:fae:fae:fae:fae:5::"
}

resource "hostingde_record" "delite-wg-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "delite.wg.pub.solar"
  type    = "AAAA"
  content = "fd00:fae:fae:fae:fae:6::"
}

resource "hostingde_record" "blue-shell-wg-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "blue-shell.wg.pub.solar"
  type    = "AAAA"
  content = "fd00:fae:fae:fae:fae:7::"
}

resource "hostingde_record" "limes-wg-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "limes.wg.pub.solar"
  type    = "AAAA"
  content = "fd00:fae:fae:fae:fae:8::"
}

resource "hostingde_record" "metronom-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "metronom.pub.solar"
  type    = "A"
  content = "49.13.236.167"
}

resource "hostingde_record" "metronom-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "metronom.pub.solar"
  type    = "AAAA"
  content = "2a01:4f8:c2c:7082::1"
}

resource "hostingde_record" "mail-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "mail.pub.solar"
  type    = "A"
  content = "49.13.236.167"
}

resource "hostingde_record" "mail-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "mail.pub.solar"
  type    = "AAAA"
  content = "2a01:4f8:c2c:7082::1"
}

resource "hostingde_record" "trinkgenossin-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "trinkgenossin.pub.solar"
  type    = "A"
  content = "85.215.152.22"
}

resource "hostingde_record" "trinkgenossin-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "trinkgenossin.pub.solar"
  type    = "AAAA"
  content = "2a01:239:35d:f500::1"
}

resource "hostingde_record" "delite-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "delite.pub.solar"
  type    = "A"
  content = "5.255.119.132"
}

resource "hostingde_record" "delite-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "delite.pub.solar"
  type    = "AAAA"
  content = "2a04:52c0:124:9d8c::2"
}

resource "hostingde_record" "blue-shell-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "blue-shell.pub.solar"
  type    = "A"
  content = "194.13.83.205"
}

resource "hostingde_record" "blue-shell-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "blue-shell.pub.solar"
  type    = "AAAA"
  content = "2a03:4000:43:24e::1"
}

resource "hostingde_record" "limes-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "limes.pub.solar"
  type    = "AAAA"
  content = "2001:4d88:1ffa:26::15"
}

resource "hostingde_record" "pub-solar-auth" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "auth.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-mas" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "mas.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "buckets-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "buckets.pub.solar"
  type    = "A"
  content = "85.215.152.22"
}

resource "hostingde_record" "buckets-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "buckets.pub.solar"
  type    = "AAAA"
  content = "2a01:239:35d:f500::1"
}

resource "hostingde_record" "pub-solar-buckets-wildcard" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "*.buckets.pub.solar"
  type    = "CNAME"
  content = "buckets.pub.solar"
}

resource "hostingde_record" "pub-solar-web" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "web.pub.solar"
  type    = "CNAME"
  content = "buckets.pub.solar"
}

resource "hostingde_record" "pub-solar-web-wildcard" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "*.web.pub.solar"
  type    = "CNAME"
  content = "buckets.pub.solar"
}

resource "hostingde_record" "tankstelle-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "tankstelle.pub.solar"
  type    = "A"
  content = "80.244.242.6"
}

resource "hostingde_record" "tankstelle-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "tankstelle.pub.solar"
  type    = "AAAA"
  content = "2001:4d88:1ffa:26::5"
}

resource "hostingde_record" "pub-solar-alerts" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "alerts.wg.pub.solar"
  type    = "CNAME"
  content = "trinkgenossin.wg.pub.solar"
}

resource "hostingde_record" "pub-solar-git" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "git.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-rss" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "rss.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-stream" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "stream.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-obs-portal" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "obs-portal.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-collabora" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "collabora.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-ALIAS" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "pub.solar"
  type    = "ALIAS"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-chat" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "chat.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-photos" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "photos.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-cloud" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "cloud.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-whiteboard" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "whiteboard.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-janus" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "janus.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-signaling" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "signaling.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-turn" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "turn.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-grafana" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "grafana.pub.solar"
  type    = "CNAME"
  content = "trinkgenossin.pub.solar"
}

resource "hostingde_record" "pub-solar-files" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "files.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-search" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "search.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-stickers-chat" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "stickers.chat.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-wiki" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "wiki.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-mastodon" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "mastodon.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-matrix" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "matrix.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-tmate" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "tmate.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-www" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "www.pub.solar"
  type    = "CNAME"
  content = "nachtigall.pub.solar"
}

resource "hostingde_record" "pub-solar-spf" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "pub.solar"
  type    = "TXT"
  content = "v=spf1 a:mail.pub.solar a:list.pub.solar ~all"
}

resource "hostingde_record" "pub-solar-list-spf" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "list.pub.solar"
  type    = "TXT"
  content = "v=spf1 a:list.pub.solar ?all"
}

resource "hostingde_record" "pub-solar-dmarc" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "_dmarc.pub.solar"
  type    = "TXT"
  content = "v=DMARC1; p=reject;"
}

resource "hostingde_record" "pub-solar-list-dmarc" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "_dmarc.list.pub.solar"
  type    = "TXT"
  content = "v=DMARC1; p=reject;"
}

resource "hostingde_record" "pub-solar-dkim" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "mail._domainkey.pub.solar"
  type    = "TXT"
  content = "v=DKIM1;k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDI333HhjmVmDYc5hYTtmB6o9KYb782xw+ewH1eQlpFcCMyJ1giYFeGKviNki9uSm52tk34zUIthsqJMRlz2WsKGgk4oq3MRtgPtogxbh1ipJlynXejPU5WVetjjMnwr6AtV1DP1Sv4n5Vz0EV8cTi3tRZdgYpG6hlriiHXbrvlIwIDAQAB"
}

resource "hostingde_record" "pub-solar-dkim-2048" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "mail-rsa-2048._domainkey.pub.solar"
  type    = "TXT"
  content = "v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2IOqNleB9jzhjZsL0wDShy4jxh5hycBKwoYgMPVcbMk9JqwLtTkfZjhldJDxK5U05ujaMFPoJu9ruPosrSSxMQiM2Z54zTkOOiiZJ22M8UGHf3+STpX/bX6G/PhaUm93yJU9Jz/puvtDEG+EYm6pw3qa337rREOw+Z8xQo7Awn6NrTHa9sffRYe+WDD40kFR6pJKuQSYc+0LufFfSABzgLjt3olvmn8Z0jDHOtPMiev0IcY+JR1ltu4dyh+MQwZle8lLs3TH1xLbIShmh2ryhhN+cBuVUN6wMRRc4Tu4eOknXIjPDJWtcEKBfKBDSjVinuhBK9/Un1KxavCSHY3+QQIDAQAB"
}

resource "hostingde_record" "pub-solar-mx" {
  zone_id  = hostingde_zone.pub-solar.id
  name     = "pub.solar"
  type     = "MX"
  priority = 10
  content  = "mail.pub.solar"
}

resource "hostingde_record" "pub-solar-list-mx" {
  zone_id  = hostingde_zone.pub-solar.id
  name     = "list.pub.solar"
  type     = "MX"
  priority = 10
  content  = "list.pub.solar"
}

resource "hostingde_record" "list-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "list.pub.solar"
  type    = "A"
  content = "138.201.80.102"
}

resource "hostingde_record" "list-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "list.pub.solar"
  type    = "AAAA"
  content = "2a01:4f8:172:1c25::1"
}

resource "hostingde_record" "nachtigall-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "nachtigall.pub.solar"
  type    = "A"
  content = "138.201.80.102"
}

resource "hostingde_record" "nachtigall-AAAA" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "nachtigall.pub.solar"
  type    = "AAAA"
  content = "2a01:4f8:172:1c25::1"
}

resource "hostingde_record" "underground-A" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "underground.pub.solar"
  type    = "A"
  content = "80.244.242.3"
}

resource "hostingde_record" "pub-solar-test" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "test.pub.solar"
  type    = "CNAME"
  content = "underground.pub.solar"
}

resource "hostingde_record" "pub-solar-mas-test" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "mas.test.pub.solar"
  type    = "CNAME"
  content = "underground.pub.solar"
}

resource "hostingde_record" "pub-solar-matrix-test" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "matrix.test.pub.solar"
  type    = "CNAME"
  content = "underground.pub.solar"
}

resource "hostingde_record" "pub-solar-chat-test" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "chat.test.pub.solar"
  type    = "CNAME"
  content = "underground.pub.solar"
}

resource "hostingde_record" "pub-solar-cloud-test" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "cloud.test.pub.solar"
  type    = "CNAME"
  content = "underground.pub.solar"
}

resource "hostingde_record" "pub-solar-stickers-chat-test" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "stickers.chat.test.pub.solar"
  type    = "CNAME"
  content = "underground.pub.solar"
}

resource "hostingde_record" "pub-solar-auth-test" {
  zone_id = hostingde_zone.pub-solar.id
  name    = "auth.test.pub.solar"
  type    = "CNAME"
  content = "underground.pub.solar"
}

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
    hostname = "limes.wg"
    type     = "A"
    address  = "10.7.6.8"
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
    hostname = "limes.wg"
    type     = "AAAA"
    address  = "fd00:fae:fae:fae:fae:8::"
  }
  record {
    hostname = "metronom"
    type     = "A"
    address  = "49.13.236.167"
  }
  record {
    hostname = "metronom"
    type     = "AAAA"
    address  = "2a01:4f8:c2c:7082::1"
  }
  record {
    hostname = "mail"
    type     = "A"
    address  = "49.13.236.167"
  }
  record {
    hostname = "mail"
    type     = "AAAA"
    address  = "2a01:4f8:c2c:7082::1"
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
    hostname = "limes"
    type     = "AAAA"
    address  = "2001:4d88:1ffa:26::15"
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
    type     = "AAAA"
    address  = "2a01:239:35d:f500::1"
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
    type     = "A"
    address  = "80.244.242.6"
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
    hostname = "photos"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
    ttl      = 300
  }
  record {
    hostname = "cloud"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "whiteboard"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "janus"
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
  }
  record {
    hostname = "signaling"
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
    type     = "CNAME"
    address  = "nachtigall.pub.solar."
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
    hostname = "mail-rsa-2048._domainkey"
    type     = "TXT"
    address  = "v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2IOqNleB9jzhjZsL0wDShy4jxh5hycBKwoYgMPVcbMk9JqwLtTkfZjhldJDxK5U05ujaMFPoJu9ruPosrSSxMQiM2Z54zTkOOiiZJ22M8UGHf3+STpX/bX6G/PhaUm93yJU9Jz/puvtDEG+EYm6pw3qa337rREOw+Z8xQo7Awn6NrTHa9sffRYe+WDD40kFR6pJKuQSYc+0LufFfSABzgLjt3olvmn8Z0jDHOtPMiev0IcY+JR1ltu4dyh+MQwZle8lLs3TH1xLbIShmh2ryhhN+cBuVUN6wMRRc4Tu4eOknXIjPDJWtcEKBfKBDSjVinuhBK9/Un1KxavCSHY3+QQIDAQAB"
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
    hostname = "cloud.test"
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
