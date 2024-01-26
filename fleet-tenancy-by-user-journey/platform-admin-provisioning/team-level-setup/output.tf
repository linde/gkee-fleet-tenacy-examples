
output "fleet_project" {
  value = local.fleet_project
}

output "random_id_rand" {
  value = random_id.rand
}

output "scope" {
  value = google_gke_hub_scope.team_scope
}

output "namespaces" {
  value = google_gke_hub_namespace.platformadmin_team_namespaces
}
