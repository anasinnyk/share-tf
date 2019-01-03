resource "google_compute_address" "ip_address" {
  name    = "${var.name}-static-ip"
  region  = "${var.region}"
  project = "${var.project}"
}
