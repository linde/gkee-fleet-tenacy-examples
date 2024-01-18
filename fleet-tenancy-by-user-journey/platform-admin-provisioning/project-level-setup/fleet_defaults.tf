

// policy defaults
resource "google_gke_hub_feature" "fleet_policy_defaults" {
  project  = var.fleet_project
  location = "global"
  name     = "policycontroller"

  fleet_default_member_config {
    policycontroller {
      policy_controller_hub_config {
        install_spec = "INSTALL_SPEC_ENABLED"
        policy_content {
          bundles {
            bundle = "cis-k8s-v1.5.1"
          }
        }
        audit_interval_seconds    = 30
        referential_rules_enabled = true
      }
    }
  }
  depends_on = [
    google_project_service.gkee,
    google_project_service.gkehub,
    google_project_service.policycontroller
  ]
}

/***
// example config package defaults
resource "google_gke_hub_feature" "fleet_config_defaults" {
  project  = var.fleet_project
  location = "global"
  name     = "configmanagement"
  fleet_default_member_config {
    configmanagement {
      config_sync {
        source_format = "unstructured"
        git {
          sync_repo   = "https://github.com/linde/gkee-fleet-tenacy-examples.git"
          sync_branch = "main"
          secret_type = "none"
          policy_dir  = "fleet-tenancy-with-defaults/k8s-policy-dir/policy"
        }
      }
    }
  }
  depends_on = [
    google_project_service.gkee,
    google_project_service.gkehub,
    google_project_service.configmanagement
  ]
}
***/

// mesh defaults
resource "google_gke_hub_feature" "mesh_config_defaults" {
  project  = var.fleet_project
  location = "global"
  name     = "servicemesh"
  fleet_default_member_config {
    mesh {
      management = "MANAGEMENT_AUTOMATIC"
    }
  }
  depends_on = [
    google_project_service.gkee,
    google_project_service.gkehub,
    google_project_service.meshconfig
  ]
}

// the fleet observeability feature for log management
resource "google_gke_hub_feature" "fleetobservability" {
  name     = "fleetobservability"
  project  = var.fleet_project
  location = "global"
  spec {
    fleetobservability {
      logging_config {
        default_config {
          // mode = "MOVE"
        }
        fleet_scope_logs_config {
          mode = "MOVE"
        }
      }
    }
  }

  depends_on = [
    google_project_service.gkee,
    google_project_service.gkehub,
  ]
}


// cluster managed capabilities are managed in the fleet resource
resource "google_gke_hub_fleet" "default" {
  project = var.fleet_project
  default_cluster_config {
    security_posture_config {
      mode               = "BASIC"
      vulnerability_mode = "VULNERABILITY_BASIC"
    }
  }

  depends_on = [
    google_project_service.gkee,
    google_project_service.gkehub,
    google_project_service.containersecurity
  ]
}

