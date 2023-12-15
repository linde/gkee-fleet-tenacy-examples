
// TODO these should be vars, trying to keep everything
// in one page for consciseness.

locals {
  fleet_project       = "stevenlinde-general-2023"
  region              = "us-central1"
  cluster_zones       = "${local.region}-c"
  team_principal      = "acme-dev@acme.com"
  team_principal_role = "EDIT"
  num_clusters        = 1
  node_count          = 3
  namespace_names     = ["acme-anvils", "acme-explosives"]
}

provider "google" {
}

resource "random_id" "rand" {
  byte_length = 4
}

//////////////////////////////////////////////////////////////////////
// first of all, charlie fleet-level setup stuff -- once per fleet host project

// policy defaults
resource "google_gke_hub_feature" "fleet_policy_defaults" {
  project  = local.fleet_project
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
}

// config package defaults
resource "google_gke_hub_feature" "fleet_config_defaults" {
  project  = local.fleet_project
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
}

// next, provision capacity. it will be born-in-fleet and get any fleet config above
resource "google_container_cluster" "acme_clusters" {
  project            = local.fleet_project
  count              = local.num_clusters
  location           = local.cluster_zones
  name               = "gkee-fleet-tf-${random_id.rand.hex}-${count.index}"
  initial_node_count = local.node_count
  fleet {
    project = local.fleet_project
  }
  deletion_protection = false
  depends_on = [
    google_gke_hub_feature.fleet_config_defaults,
    google_gke_hub_feature.fleet_policy_defaults
  ]
}

//////////////////////////////////////////////////////////////////////
// now, charlie addresses team bootstrap stuff. happens once per team

// first the team scope resource itself
resource "google_gke_hub_scope" "acme_scope" {
  project  = local.fleet_project
  scope_id = "gkee-fleet-tf-${random_id.rand.hex}"
}

// and then give them local.team_principal_role access in the cluster
resource "google_gke_hub_scope_rbac_role_binding" "acme_rolebinding" {
  project                    = local.fleet_project
  scope_rbac_role_binding_id = "acme-dev-viewers"
  scope_id                   = google_gke_hub_scope.acme_scope.scope_id
  user                       = local.team_principal
  role {
    predefined_role = local.team_principal_role
  }
}

// last step at the team level, bind the clusters to the 
// team's scope to enable capacity for them

locals {
  // for now use regexes on the membership resource. we will have outputs for this
  // fleet host project is match #0
  // location is match #1
  // membership is match #2
  membership_re = "//gkehub.googleapis.com/projects/([^/]*)/locations/([^/]*)/memberships/([^/]*)$"
}

resource "google_gke_hub_membership_binding" "acme_scope_clusters" {
  count = local.num_clusters

  project               = local.fleet_project
  membership_binding_id = "${google_gke_hub_scope.acme_scope.scope_id}-${count.index}"
  scope                 = google_gke_hub_scope.acme_scope.name
  membership_id         = regex(local.membership_re, google_container_cluster.acme_clusters[count.index].fleet[0].membership)[2]
  location              = regex(local.membership_re, google_container_cluster.acme_clusters[count.index].fleet[0].membership)[1]
}

//////////////////////////////////////////////////////////////////////
// Lastly alice level fleet namespace provisioning, they will be sync'ed to all bound clusters
// for the scope and pick up any config from the configmanagement repo that has appropriate
// namespace and/or scope selectors. this is done one per set of namespaces needed.

resource "google_gke_hub_namespace" "acme_scope_namespaces" {
  for_each = toset(local.namespace_names)

  project            = local.fleet_project
  scope_namespace_id = "${each.key}-${random_id.rand.hex}"
  scope_id           = google_gke_hub_scope.acme_scope.scope_id
  scope              = google_gke_hub_scope.acme_scope.id
}
