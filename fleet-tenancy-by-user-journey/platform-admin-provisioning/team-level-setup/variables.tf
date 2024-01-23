

variable "team_id" {
  type    = string
  default = "app-frontend"
}

variable "team_namespaces" {
  type    = list(string)
  default = ["www", "support"]
}

variable "scope_email_group" {
  type = string
}

