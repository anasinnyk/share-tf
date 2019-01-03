resource "google_compute_network" "net" {
  name                    = "${var.name}-net"
  project                 = "${var.project}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  network       = "${google_compute_network.net.self_link}"
  project       = "${var.project}"
  region        = "${var.region}"
  ip_cidr_range = "${var.instances_cidr}"
}

resource "google_compute_firewall" "deny" {
  count   = "${length(var.firewall_deny_rules)}"
  name    = "${var.name}-${lookup(var.firewall_deny_rules[count.index], "protocol")}-deny-rule"
  project = "${var.project}"
  network = "${google_compute_network.net.self_link}"

  deny {
    protocol = "${lookup(var.firewall_deny_rules[count.index], "protocol")}"
    ports    = ["${compact(split(",", lookup(var.firewall_deny_rules[count.index], "ports")))}"]
  }
}

resource "google_compute_firewall" "allow" {
  count   = "${length(var.firewall_allow_rules)}"
  name    = "${var.name}-${lookup(var.firewall_allow_rules[count.index], "protocol")}-allow-rule"
  project = "${var.project}"
  network = "${google_compute_network.net.self_link}"

  allow {
    protocol = "${lookup(var.firewall_allow_rules[count.index], "protocol")}"
    ports    = ["${compact(split(",", lookup(var.firewall_allow_rules[count.index], "ports")))}"]
  }
}
