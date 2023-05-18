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
  server_addr = "" # Dummy value required when using port_forward=true
  username    = "admin"
  password    = var.argocd_admin_password

  port_forward                = true
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
