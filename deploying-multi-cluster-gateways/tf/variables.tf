
variable "gcp_project" {
  type = string
}

variable "cluster_prefix" {
  type    = string
  default = "mcg-tf"
}

variable "worker_locations" {
  type    = list(string)
  default = ["us-central1", "us-east1"]
}

variable "hub_location" {
  type    = string
  default = "us-central1"
}

variable "helm_chart_root" {
  type    = string
  default = "../helm-charts"
}

resource "random_id" "rand" {
  byte_length = 4
}