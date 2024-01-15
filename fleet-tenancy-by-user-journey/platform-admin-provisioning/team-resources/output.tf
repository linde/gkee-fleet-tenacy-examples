

output "connect_gateway_host" {
  // per https://github.com/binxio/gcp-private-gke-connect-gateway-deployment-example
  value = "https://connectgateway.googleapis.com/v1/projects/${local.fleet_project_id}/locations/${google_gke_hub_membership_binding.acme_scope_clusters[0].location}/gkeMemberships/${google_gke_hub_membership_binding.acme_scope_clusters[0].membership_id}"
}

