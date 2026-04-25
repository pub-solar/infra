resource "hostingde_zone" "lunar-page" {
  name = "lunar.page"
  type = "NATIVE"
}

resource "hostingde_record" "lunar-page-A" {
  zone_id = hostingde_zone.lunar-page.id
  name    = "lunar.page"
  type    = "A"
  content = "85.215.152.22"
}

resource "hostingde_record" "lunar-page-AAAA" {
  zone_id = hostingde_zone.lunar-page.id
  name    = "lunar.page"
  type    = "AAAA"
  content = "2a01:239:35d:f500::1"
}

resource "hostingde_record" "lunar-page-wildcard" {
  zone_id = hostingde_zone.lunar-page.id
  name    = "*.lunar.page"
  type    = "CNAME"
  content = "lunar.page"
}

resource "hostingde_record" "lunar-page-TXT" {
  zone_id = hostingde_zone.lunar-page.id
  name    = "lunar.page"
  type    = "TXT"
  content = "pages.lunar-page.pub-solar.lunar.page"
}
