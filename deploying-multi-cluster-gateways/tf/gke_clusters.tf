

// TODO after tear down, rename to just clusters
resource "google_container_cluster" "team_clusters" {

  for_each = toset(var.worker_locations)

  project  = var.gcp_project
  location = each.value
  name     = "${var.cluster_prefix}-${random_id.rand.hex}-${each.value}"

  enable_autopilot = true

  fleet {
    project = var.gcp_project
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

  workload_identity_config {
    workload_pool = "${var.gcp_project}.svc.id.goog"
  }

  deletion_protection = false
}

resource "google_container_cluster" "hub" {

  project  = var.gcp_project
  location = var.hub_location
  name     = "hub-${random_id.rand.hex}"

  enable_autopilot = true

  fleet {
    project = var.gcp_project
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

  workload_identity_config {
    workload_pool = "${var.gcp_project}.svc.id.goog"
  }

  deletion_protection = false
}
