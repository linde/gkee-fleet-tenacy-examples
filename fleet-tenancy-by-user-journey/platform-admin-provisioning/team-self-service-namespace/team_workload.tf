


resource "kubernetes_deployment" "nginx" {

  provider = kubernetes.connect_0
  metadata {
    name      = "nginx"
    namespace = google_gke_hub_namespace.self_service_namespace.scope_namespace_id
  }
  spec {
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
        }
      }
    }
  }

}