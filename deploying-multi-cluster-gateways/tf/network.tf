

# based on https://cloud.google.com/kubernetes-engine/docs/how-to/enabling-multi-cluster-gateways#requirements
# we need a "vpc native" cluster. the following attempts to do that

# resource "google_compute_network" "network" {
#   project                 = var.gcp_project
#   name                    = "mcg-network"
#   auto_create_subnetworks = false
#   depends_on = [
#     time_sleep.post_services_wait
#   ]
# }

# resource "google_compute_subnetwork" "hub" {
#   project       = var.gcp_project
#   name          = "hub-subnetwork"
#   ip_cidr_range = "10.0.0.0/16"
#   region        = var.hub_location
#   network       = google_compute_network.network.id
# }


# resource "google_compute_subnetwork" "workers" {
#   project  = var.gcp_project
#   for_each = toset(var.worker_locations)
#   name     = "cluster-subnetwork"
#   // h/t andrewpeabody
#   ip_cidr_range = "10.1.${index(var.worker_locations, each.value) * 4}.0/22"
#   region        = each.value
#   network       = google_compute_network.network.id
# }

