resource "kubernetes_namespace" "namespaces" {
  count = "${length(var.namespaces)}"

  metadata = {
    name   = "${lookup(var.namespaces[count.index], "name")}"
  }
}
