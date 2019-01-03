variable "name" {}
variable "instances_cidr" {}
variable "region" {}
variable "project" {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "cloudflare_org_id" {}
variable "cloudflare_zone" {}
variable "initial_node_count" {
  default = 3
}
variable "k8s_version" {
  default = "1.11.2-gke.18"
}
variable "master_machine_type" {
  default = "n1-standard-2"
}
variable "pools" {
  type = "list"
  default = []
}
variable "firewall_deny_rules" {
  type = "list"
  default = []
}
variable "firewall_allow_rules" {
  type = "list"
  default = []
}
variable "namespaces" {
  type = "list"
  default = []
}
variable "service_accounts" {
  type = "list"
  default = []
}
variable "charts" {
  type = "list"
  default = []
}
variable "cloudflare_domains" {
  type = "list"
  default = []
}
