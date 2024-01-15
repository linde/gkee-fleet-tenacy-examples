
data "terraform_remote_state" "team_level" {
  backend = "local"

  config = {
    path = "../team-level-setup/terraform.tfstate"
  }
}

data "terraform_remote_state" "team_resources" {
  backend = "local"

  config = {
    path = "../team-resources/terraform.tfstate"
  }
}


locals {
  fleet_project = data.terraform_remote_state.team_level.outputs.fleet_project
  rand          = data.terraform_remote_state.team_level.outputs.random_id_rand
  namespaces    = data.terraform_remote_state.team_level.outputs.namespaces
  scope         = data.terraform_remote_state.team_level.outputs.scope

  connect_gateway_hosts = data.terraform_remote_state.team_resources.outputs.connect_gateway_hosts
}

