data "template_file" "values" {
  count = "${length(var.charts)}"
  template = "${file(lookup(var.charts[count.index], "values"))}"
  vars {
    project      = "${var.project}"
    region       = "${var.region}"
    chart        = "${lookup(var.charts[count.index], "name")}"
    ip_address   = "${google_compute_address.ip_address.address}"
    address_name = "${google_compute_address.ip_address.name}"
  }
}

resource "helm_release" "charts" {
  count     = "${length(var.charts)}"
  name      = "${lookup(var.charts[count.index], "name")}"
  chart     = "${lookup(var.charts[count.index], "chart", format("stable/%s", lookup(var.charts[count.index], "name")))}"
  version   = "${lookup(var.charts[count.index], "version", "")}"
  namespace = "${lookup(var.charts[count.index], "namespace", "default")}"
  timeout   = "${lookup(var.charts[count.index], "timeout", 300)}"
  values    = [
    "${element(data.template_file.values.*.rendered, count.index)}"
  ]
  depends_on = ["kubernetes_cluster_role_binding.crb"]
}
