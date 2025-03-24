terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.26.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "google" {}
data "google_client_config" "default" {}


// the following are k8s specific providers, annoyingly one per cluster 
// which we access via locals to shorten resource paths

locals {
  mcg_0 = google_container_cluster.team_clusters[var.worker_locations[0]]
  mcg_1 = google_container_cluster.team_clusters[var.worker_locations[1]]
}

provider "helm" {
  alias = "mcg_0"
  kubernetes {
    host                   = local.mcg_0.endpoint
    client_key             = local.mcg_0.master_auth[0].client_key
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(local.mcg_0.master_auth[0].cluster_ca_certificate)
  }
}

provider "helm" {
  alias = "mcg_1"
  kubernetes {
    host                   = local.mcg_1.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(local.mcg_1.master_auth[0].cluster_ca_certificate)
  }
}

provider "helm" {
  alias = "hub"
  kubernetes {
    host                   = google_container_cluster.hub.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.hub.master_auth[0].cluster_ca_certificate)
  }
}
