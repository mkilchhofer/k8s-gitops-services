provider "akeyless" {
  api_gateway_address = "https://api.eu.akeyless.io"

  api_key_login {
    access_id  = var.akeyless_access_id
    access_key = var.akeyless_access_key
  }
}

provider "helm" {
  # Configuration options
  kubernetes = {
    host                   = "https://192.168.92.31:6443"
    cluster_ca_certificate = local.kubernetes_cluster_ca_certificate

    client_certificate = local.kubernetes_client_certificate
    client_key         = local.kubernetes_client_key
  }
}
provider "kubernetes" {
  # Configuration options
  host                   = "https://192.168.92.31:6443"
  cluster_ca_certificate = local.kubernetes_cluster_ca_certificate

  client_certificate = local.kubernetes_client_certificate
  client_key         = local.kubernetes_client_key
}

provider "argocd" {
  username    = "admin"
  password    = data.akeyless_static_secret.argocd.key_value_pairs["admin_password"]

  port_forward_with_namespace = kubernetes_namespace_v1.argocd.metadata.0.name

  # grpc_web = true

  kubernetes {
    host                   = "https://192.168.92.31:6443"
    cluster_ca_certificate = local.kubernetes_cluster_ca_certificate

    client_certificate = local.kubernetes_client_certificate
    client_key         = local.kubernetes_client_key
  }
}
