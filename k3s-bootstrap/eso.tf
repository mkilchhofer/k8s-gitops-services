resource "kubernetes_namespace_v1" "eso" {
  metadata {
    name = "external-secrets"
  }
}

resource "kubernetes_secret_v1" "doppler" {
  metadata {
    name      = "doppler-token-k3s-secrets"
    namespace = kubernetes_namespace_v1.eso.metadata.0.name
  }

  data = {
    dopplerToken = var.doppler_service_token
  }
}
