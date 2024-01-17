
// here we use the output variable from the team-resources project. they come in an array,
// one for each cluster bound to the team scope. each provider can only deal with one 
// connection so you need a specific provider for each cluster, respectively. this provider
// gets the first one, ie the one with subscript 0.

provider "kubernetes" {

  alias = "connect_0"
  host  = local.connect_gateway_hosts[0]
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}

