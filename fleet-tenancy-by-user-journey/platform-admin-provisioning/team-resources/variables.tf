
variable "cluster_project" {
  type = string
}

variable "cluster_location" {
  type    = string
  default = "us-west1"
}

variable "cluster_count" {
  type    = number
  default = 1
}

variable "cluster_prefix" {
  type        = string
  default     = "team-resources"
  description = "supply a prefix which will get a random string appended and will be used in GCP fleet resources"
}
