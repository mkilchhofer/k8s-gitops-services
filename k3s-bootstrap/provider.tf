provider "akeyless" {
  api_gateway_address = "https://api.akeyless.io"

  api_key_login {
    access_id  = var.akeyless_access_id
    access_key = var.akeyless_access_key
  }
}

provider "helm" {
  # Configuration options
  kubernetes {
    host                   = "https://192.168.92.31:6443"
    cluster_ca_certificate = var.kubernetes_cluster_ca_certificate

    client_certificate = var.kubernetes_client_certificate
    client_key         = var.kubernetes_client_key
  }
}
provider "kubernetes" {
  # Configuration options
  host                   = "https://192.168.92.31:6443"
  cluster_ca_certificate = var.kubernetes_cluster_ca_certificate

  client_certificate = var.kubernetes_client_certificate
  client_key         = var.kubernetes_client_key
}

provider "argocd" {
  username    = "admin"
  password    = var.argocd_admin_password

  port_forward_with_namespace = kubernetes_namespace.argocd.metadata.0.name

  plain_text = true
  # grpc_web = true

  kubernetes {
    host                   = "https://192.168.92.31:6443"
    cluster_ca_certificate = var.kubernetes_cluster_ca_certificate

    client_certificate = var.kubernetes_client_certificate
    client_key         = var.kubernetes_client_key
  }
}
