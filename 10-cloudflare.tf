provider "cloudflare" {
  email  = "${var.cloudflare_email}"
  token  = "${var.cloudflare_token}"
  org_id = "${var.cloudflare_org_id}"
}

resource "cloudflare_record" "domain" {
  count   = "${length(var.cloudflare_domains)}"
  domain  = "${var.cloudflare_zone}"
  name    = "${var.cloudflare_domains[count.index]}"
  value   = "${google_compute_address.ip_address.address}"
  type    = "A"
  proxied = true
}

resource "cloudflare_page_rule" "page_rule" {
  count  = "${length(var.cloudflare_domains)}"
  zone   = "${var.cloudflare_zone}"
  target = "${var.cloudflare_domains[count.index]}.${var.cloudflare_zone}/*"

  actions = {
    ssl = "flexible"
    waf = "off"
  }
}
