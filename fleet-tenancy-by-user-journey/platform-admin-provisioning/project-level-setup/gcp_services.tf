
locals {
  disable_on_destroy = false
}

resource "google_project_service" "services" {
  project = var.fleet_project
  for_each = toset([
    "container.googleapis.com",
    "anthos.googleapis.com",
    "gkehub.googleapis.com",
    "gkeconnect.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "anthospolicycontroller.googleapis.com",
    "meshconfig.googleapis.com",
    "meshca.googleapis.com",
    "containersecurity.googleapis.com",
    "gkemulticloud.googleapis.com",
    "logging.googleapis.com",
  ])
  service            = each.value
  disable_on_destroy = false
}


