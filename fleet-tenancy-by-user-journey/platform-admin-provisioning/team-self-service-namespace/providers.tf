

provider "kubernetes" {

  alias = "connect_0"
  host  = local.connect_gateway_hosts[0]
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}

