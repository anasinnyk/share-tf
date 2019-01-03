resource "google_container_cluster" "cluster" {
  provider           = "google-beta"
  name               = "${var.name}"
  region             = "${var.region}"
  network            = "${google_compute_network.net.self_link}"
  subnetwork         = "${google_compute_subnetwork.subnet.self_link}"
  min_master_version = "${var.k8s_version}"
  initial_node_count = "${var.initial_node_count}"
  node_config        = {
    machine_type = "${var.master_machine_type}"
  }
}
