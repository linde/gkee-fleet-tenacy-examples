data "google_project" "cluster_project" {
  project_id = var.cluster_project
}
locals {
  cluster_project_number = data.google_project.cluster_project.number
  default_sa_email       = "${local.cluster_project_number}-compute@developer.gserviceaccount.com"
  default_sa_member      = "serviceAccount:${local.default_sa_email}"
}
resource "google_project_iam_member" "metricWriter" {
  project = var.cluster_project
  role    = "roles/monitoring.metricWriter"
  member  = local.default_sa_member
}
resource "google_project_iam_member" "monitoring_viewer" {
  project = var.cluster_project
  role    = "roles/monitoring.viewer"
  member  = local.default_sa_member
}

resource "google_project_iam_member" "logging_bucket_writer" {
  project = var.cluster_project
  role    = "roles/logging.logWriter"
  member  = local.default_sa_member
}

