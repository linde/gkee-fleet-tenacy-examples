


// This is an example to show a team specific custom resource, in this case
// a policy to requite strict mTLS. The CRD comes from the mesh feature.
resource "kubernetes_manifest" "strict_mtls" {

  provider = kubernetes.connect_0

  manifest = {
    "apiVersion" = "security.istio.io/v1beta1"
    "kind"       = "PeerAuthentication"
    "metadata" = {
      "name"      = "strict-mtls-peerauthn"
      "namespace" = "default"
    }
    "spec" = {
      "mtls" = {
        "mode" = "STRICT"
      }
    }
  }
}
