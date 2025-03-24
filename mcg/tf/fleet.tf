
resource "google_gke_hub_fleet" "fleet" {
  project = var.gcp_project

  depends_on = [
    time_sleep.post_services_wait
  ]
}

### Multi-Cluster Gateway
resource "google_gke_hub_feature" "multiclusteringress" {
  project  = var.gcp_project
  name     = "multiclusteringress"
  location = "global"
  spec {
    multiclusteringress {
      config_membership = trimprefix(google_container_cluster.hub.fleet[0].membership, "//gkehub.googleapis.com/")
    }
  }
  depends_on = [
    google_gke_hub_fleet.fleet
  ]
}

// wait to allow time for services accounts and for the 
// feature controller to write the CRDs into the cluster
resource "time_sleep" "post_mci" {
  create_duration = "1m"
  depends_on = [
    google_gke_hub_feature.multiclusteringress
  ]
}

