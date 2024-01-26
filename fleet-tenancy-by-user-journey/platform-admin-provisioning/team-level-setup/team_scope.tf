
// first the team scope resource itself
resource "google_gke_hub_scope" "team_scope" {
  project  = local.fleet_project
  scope_id = var.team_id
}


# this preserves the random hash to disambiguate fleet namespaces 
# this otherwise have to be unique within a fleet.
resource "google_gke_hub_namespace" "platformadmin_team_namespaces" {
  for_each = toset(var.team_namespaces)

  project            = local.fleet_project
  scope_namespace_id = "${each.key}-${random_id.rand.hex}"
  scope_id           = google_gke_hub_scope.team_scope.scope_id
  scope              = google_gke_hub_scope.team_scope.id
}

resource "google_gke_hub_scope_rbac_role_binding" "scope_rbac_role_binding" {
  project                    = local.fleet_project
  scope_rbac_role_binding_id = google_gke_hub_scope.team_scope.scope_id
  scope_id                   = google_gke_hub_scope.team_scope.scope_id
  group                      = var.scope_email_group
  role {
    predefined_role = "EDIT"
  }
}

