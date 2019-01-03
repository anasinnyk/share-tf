resource "google_container_node_pool" "node_pools" {
  provider    = "google-beta"
  count       = "${length(var.pools)}"
  name        = "${lookup(var.pools[count.index], "name")}-pool"
  region      = "${var.region}"
  cluster     = "${google_container_cluster.cluster.name}"
  node_count  = "${lookup(var.pools[count.index], "count")}"
  version     = "${var.k8s_version}"
  node_config = {
    machine_type = "${lookup(var.pools[count.index], "type")}"
    disk_size_gb = "${lookup(var.pools[count.index], "disk_size_gb")}"

    labels {
      role = "${lookup(var.pools[count.index], "name")}"
    }
  }
}
