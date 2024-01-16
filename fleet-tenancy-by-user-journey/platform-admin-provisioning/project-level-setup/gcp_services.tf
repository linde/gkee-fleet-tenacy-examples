
locals {
  disable_on_destroy = false
}


resource "google_project_service" "container" {
  project            = var.fleet_project
  service            = "container.googleapis.com"
  disable_on_destroy = local.disable_on_destroy
}

resource "google_project_service" "gkee" {
  project            = var.fleet_project
  service            = "anthos.googleapis.com"
  disable_on_destroy = local.disable_on_destroy
}

resource "google_project_service" "gkehub" {
  project            = var.fleet_project
  service            = "gkehub.googleapis.com"
  disable_on_destroy = local.disable_on_destroy
}

resource "google_project_service" "gkeconnect" {
  project            = var.fleet_project
  service            = "gkeconnect.googleapis.com"
  disable_on_destroy = local.disable_on_destroy
}

resource "google_project_service" "configmanagement" {
  project            = var.fleet_project
  service            = "anthosconfigmanagement.googleapis.com"
  disable_on_destroy = local.disable_on_destroy
}

resource "google_project_service" "policycontroller" {
  project            = var.fleet_project
  service            = "anthospolicycontroller.googleapis.com"
  disable_on_destroy = local.disable_on_destroy
}

resource "google_project_service" "meshconfig" {
  project            = var.fleet_project
  service            = "meshconfig.googleapis.com"
  disable_on_destroy = local.disable_on_destroy
}

resource "google_project_service" "meshca" {
  project            = var.fleet_project
  service            = "meshca.googleapis.com"
  disable_on_destroy = local.disable_on_destroy
}

resource "google_project_service" "containersecurity" {
  project            = var.fleet_project
  service            = "containersecurity.googleapis.com"
  disable_on_destroy = local.disable_on_destroy
}

resource "google_project_service" "attached" {
  project            = var.fleet_project
  service            = "gkemulticloud.googleapis.com"
  disable_on_destroy = local.disable_on_destroy
}


