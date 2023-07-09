resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

data "akeyless_secret" "cert_manager_ca_issuer_tls_crt" {
  path = "/k3s/cert-manager/ca-issuer_tls.crt"
}

data "akeyless_secret" "cert_manager_ca_issuer_tls_key" {
  path = "/k3s/cert-manager/ca-issuer_tls.key"
}

resource "kubernetes_secret_v1" "cert_manager_ca_issuer_key_pair" {
  metadata {
    name      = "ca-issuer-key-pair"
    namespace = kubernetes_namespace_v1.cert_manager.metadata.0.name
  }

  data = {
    "tls.crt" = data.akeyless_secret.cert_manager_ca_issuer_tls_crt.value
    "tls.key" = data.akeyless_secret.cert_manager_ca_issuer_tls_key.value
  }
}
