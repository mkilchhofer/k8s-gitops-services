resource "kubernetes_namespace_v1" "eso" {
  metadata {
    name = "external-secrets"
  }
}

resource "kubernetes_secret_v1" "name" {
  metadata {
    name      = "akeyless-secret-creds"
    namespace = kubernetes_namespace_v1.eso.metadata.0.name
  }

  data = {
    accessId        = akeyless_auth_method_api_key.k3s_eso.access_id
    accessType      = "api_key"
    accessTypeParam = akeyless_auth_method_api_key.k3s_eso.access_key
  }
}
