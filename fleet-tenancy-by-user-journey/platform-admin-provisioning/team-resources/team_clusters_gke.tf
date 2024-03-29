
resource "google_container_cluster" "team_clusters" {
  project  = var.cluster_project
  count    = var.cluster_count
  location = var.cluster_location
  name     = "${var.cluster_prefix}-${local.rand.hex}-${count.index}"

  # bc this is an example, just want zonal nodes, but big enough
  # to run all the feature controllers, etc
  initial_node_count = 3
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 8
      maximum       = 16
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 8
      maximum       = 16
    }
  }


  fleet {
    project = local.fleet_project
  }

  resource_labels = {
    # enable mesh in this fleet
    "mesh_id" = "proj-${local.fleet_project_id}"
  }

  workload_identity_config {
    # default to the cluster pool 
    workload_pool = "${var.cluster_project}.svc.id.goog"
  }

  monitoring_config {
    enable_components = ["APISERVER", "SCHEDULER", "CONTROLLER_MANAGER", "SYSTEM_COMPONENTS"]
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS", "APISERVER", "SCHEDULER", "CONTROLLER_MANAGER"]
  }
  deletion_protection = false

}

// bind the clusters to the team's scope to enable capacity for them

locals {
  // there is a bug in process to make this simpler, but for now use
  // this regex on the membership resource to extract what we need:
  //
  // fleet host project is match #0
  // location is match #1
  // membership is match #2
  membership_re = "//gkehub.googleapis.com/projects/([^/]*)/locations/([^/]*)/memberships/([^/]*)$"
}

resource "google_gke_hub_membership_binding" "team_scope_cluster_bindings" {
  count                 = var.cluster_count
  project               = local.fleet_project
  membership_binding_id = google_container_cluster.team_clusters[count.index].name
  scope                 = local.scope.name
  membership_id         = regex(local.membership_re, google_container_cluster.team_clusters[count.index].fleet[0].membership)[2]
  location              = regex(local.membership_re, google_container_cluster.team_clusters[count.index].fleet[0].membership)[1]
}

