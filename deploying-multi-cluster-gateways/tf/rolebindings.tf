
data "google_project" "cluster_project" {
  project_id = var.gcp_project
}

resource "google_project_iam_member" "networkViewer" {
  project = var.gcp_project
  role    = "roles/compute.networkViewer"
  member  = "serviceAccount:${var.gcp_project}.svc.id.goog[gke-mcs/gke-mcs-importer]"

  depends_on = [time_sleep.post_mci]
}

resource "google_project_iam_member" "containerAdmin" {
  project = var.gcp_project
  role    = "roles/container.admin"
  member  = "serviceAccount:service-${data.google_project.cluster_project.number}@gcp-sa-multiclusteringress.iam.gserviceaccount.com"

  depends_on = [time_sleep.post_mci]
}


// wait to allow time for rolebindings
resource "time_sleep" "post_rolebindings" {
  create_duration = "30s"
  depends_on = [
    google_project_iam_member.networkViewer,
    google_project_iam_member.containerAdmin,
  ]
}


