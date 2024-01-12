
data "terraform_remote_state" "team_level" {
  backend = "local"

  config = {
    path = "../team-level-setup/terraform.tfstate"
  }
}

locals {
  fleet_project = data.terraform_remote_state.team_level.outputs.fleet_project
  rand          = data.terraform_remote_state.team_level.outputs.random_id_rand
  namespaces    = data.terraform_remote_state.team_level.outputs.namespaces
  scope         = data.terraform_remote_state.team_level.outputs.scope
}


data "google_project" "fleet_project" {
  project_id = local.fleet_project
}

locals {
  fleet_project_id = data.google_project.fleet_project.number
}