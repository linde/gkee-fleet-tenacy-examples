

resource "kubernetes_deployment" "counter" {

  provider = kubernetes.connect_0
  metadata {
    name      = "count"
    namespace = google_gke_hub_namespace.self_service_namespace.scope_namespace_id
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
            "bash", "-c", "for ((i = 0; ; i++)); do echo \"$i: $(date)\"; sleep 1; done"
          ]
          resources {
            limits = {
              "memory" = "100Mi"
              "cpu"    = "100m"
            }
            requests = {
              "memory" = "50Mi"
              "cpu"    = "50m"
            }
          }
        }
      }
    }
  }

}
