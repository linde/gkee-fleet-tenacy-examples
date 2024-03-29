

output "connect_gateway_hosts" {
  // per https://github.com/binxio/gcp-private-gke-connect-gateway-deployment-example
  value = [
    for binding in google_gke_hub_membership_binding.team_scope_cluster_bindings : "https://connectgateway.googleapis.com/v1/projects/${local.fleet_project_id}/locations/${binding.location}/gkeMemberships/${binding.membership_id}"
  ]
}

