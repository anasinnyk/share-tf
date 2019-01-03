name                 = "cluster"
region               = "us-central1"
project              = "gceproject-00000"
k8s_version          = "1.11.5-gke.5"
instances_cidr       = "10.1.0.0/16"
cloudflare_email     = ""
cloudflare_token     = ""
cloudflare_org_id    = "" 
cloudflare_zone      = "example.com"
initial_node_count   = 1
firewall_allow_rules = [
  {
    protocol = "icmp"
    ports    = ""
  },
  {
    protocol = "tcp"
    ports    = "80,443"
  }
]
namespaces           = []
service_accounts     = [
  {
    name                  = "tiller",
    namespace             = "kube-system"
    cluster_role_bindings = "cluster-admin"
  }
]
charts               = [
  {
    name      = "argo"
    chart     = "argo/argo"
    values    = "helm-values/default/argo/values.yaml"
    namespace = "argo"
  },
  {
    name      = "atlantis"
    chart     = "stable/atlantis"
    values    = "helm-values/default/atlantis/values.yaml"
    namespace = "atlantis"
  },
  {
    name      = "istio"
    chart     = "istio/istio"
    values    = "helm-values/default/istio/values.yaml"
    version   = "1.1.0"
    namespace = "istio-system"
    timeout   = 600
  },
  {
    name      = "common"
    chart     = "./projects/gis/charts/common"
    values    = "./projects/gis/charts/common/values.yaml"
  },
]
cloudflare_domains   = [
  "atlantis"
]
