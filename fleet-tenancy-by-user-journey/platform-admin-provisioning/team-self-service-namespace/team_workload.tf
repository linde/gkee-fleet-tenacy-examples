

// make sure the hub has had a chance to create the self serve namespace
data "kubernetes_namespace" "self_service_namespace" {
  provider = kubernetes.connect_0
  metadata {
    name = google_gke_hub_namespace.self_service_namespace.scope_namespace_id
  }
}

resource "kubernetes_deployment" "counter" {

  provider = kubernetes.connect_0
  metadata {
    name      = "count"
    namespace = data.kubernetes_namespace.self_service_namespace.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "count"
      }
    }
    template {
      metadata {
        labels = {
          app = "count"
        }
      }
      spec {
        container {
          image = "ubuntu:14.04"
          name  = "count"
          args = [
            "bash", "-c", "for ((i = 0; ; i++)); do echo \"count $i: $(date)\"; sleep 1; done"
          ]
          resources {
            limits = {
              "memory"            = "50Mi"
              "cpu"               = "10m"
              "ephemeral-storage" = "500M"
            }
            requests = {
              "memory"            = "50Mi"
              "cpu"               = "10m"
              "ephemeral-storage" = "500M"
            }
          }
        }
      }
    }
  }

}
