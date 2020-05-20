resource "kubernetes_deployment" "predictive-gaming-deployment" {
  metadata {
    name = "predictive-gaming-deployment"
    labels = {
      app = "predictive-gaming"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "predictive-gaming"
      }
    }

    template {
      metadata {
        labels = {
          app = "predictive-gaming"
        }
      }

      spec {
        container {
          image = "gcr.io/google-samples/hello-app:1.0"
          name = "predictive-gaming"
          port {
            container_port = 8080
            protocol = "TCP"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "predictive-gaming-service" {
  metadata {
    name = "predictive-gaming-service"
  }

  spec {
    selector = {
      app = "predictive-gaming"
    }
    type = "ClusterIP"
    port {
      port = 80
      target_port = 8080
    }

  }
}

resource "kubernetes_ingress" "predictive-gaming-ingress" {
  metadata {
    name = "predictive-gaming-ingress"
  }

  spec {
    backend {
      service_name = "predictive-gaming-service"
      service_port = 80
    }

    rule {
      host "predictive-gaming.teampages.gg"
      http {
        path {
          backend {
            service_name = "predictive-gaming-service"
            service_port = 80
          }

          path = "/"
        }

      }
    }

  }
}

resource "google_dns_record_set" "predictive-gaming-dns" {
  name = "predictive-gaming.teampages.gg"
  type = "A"
  ttl  = 300

  managed_zone = "teampages-prod"

  rrdatas = "ingressIPaddr"
}
