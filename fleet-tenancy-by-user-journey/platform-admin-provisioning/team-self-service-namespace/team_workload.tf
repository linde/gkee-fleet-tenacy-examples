

provider "kubernetes" {

  alias = "connect_1"
  host  = local.connect_gateway_hosts[0]
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}



resource "kubernetes_namespace" "example" {

  provider = kubernetes.connect_1

  metadata {
    name = "marker"
  }
}