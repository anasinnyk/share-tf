provider "helm" {
  home            = "${path.module}/.helm"
  debug           = true
  install_tiller  = true
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"
  service_account = "tiller"
  kubernetes {
    host                   = "https://${google_container_cluster.cluster.endpoint}"
    username               = "${google_container_cluster.cluster.master_auth.0.username}"
    password               = "${google_container_cluster.cluster.master_auth.0.password}"
    client_certificate     = "${base64decode(google_container_cluster.cluster.master_auth.0.client_certificate)}"
    client_key             = "${base64decode(google_container_cluster.cluster.master_auth.0.client_key)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)}"
  }
}
provider "kubernetes" {
  host                   = "https://${google_container_cluster.cluster.endpoint}"
  username               = "${google_container_cluster.cluster.master_auth.0.username}"
  password               = "${google_container_cluster.cluster.master_auth.0.password}"
  client_certificate     = "${base64decode(google_container_cluster.cluster.master_auth.0.client_certificate)}"
  client_key             = "${base64decode(google_container_cluster.cluster.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)}"
}

resource "kubernetes_service_account" "sa" {
  count = "${length(var.service_accounts)}"
  metadata {
    name = "${lookup(var.service_accounts[count.index], "name")}"
    namespace = "${lookup(var.service_accounts[count.index], "namespace")}"
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "crb" {
  count = "${length(var.service_accounts)}"
  metadata {
    name = "${lookup(var.service_accounts[count.index], "name")}"
  }
  role_ref = {
    kind      = "ClusterRole"
    name      = "${lookup(var.service_accounts[count.index], "cluster_role_bindings")}"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    name      = "${lookup(var.service_accounts[count.index], "name")}"
    kind      = "ServiceAccount"
    namespace = "${lookup(var.service_accounts[count.index], "namespace")}"
    api_group = ""
  }
  depends_on = ["kubernetes_service_account.sa"]
}
