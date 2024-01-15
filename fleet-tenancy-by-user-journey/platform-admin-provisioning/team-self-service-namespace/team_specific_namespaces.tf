
// teams can use one of the namespaces allocated by the platform admin, accesible
// via local.namespaces. or self service create their own.
resource "google_gke_hub_namespace" "self_service_namespace" {
  project            = local.fleet_project
  scope_namespace_id = "selfserve-${local.rand.hex}"
  scope_id           = local.scope.scope_id
  scope              = local.scope.id
}

