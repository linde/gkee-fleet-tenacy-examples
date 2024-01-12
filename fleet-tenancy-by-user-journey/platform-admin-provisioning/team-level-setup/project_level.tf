
data "terraform_remote_state" "project_level" {
  backend = "local"

  config = {
    path = "../project-level-setup/terraform.tfstate"
  }
}

locals {
  fleet_project = data.terraform_remote_state.project_level.outputs.fleet_project
}