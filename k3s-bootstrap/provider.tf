provider "helm" {
  # Configuration options
}
provider "kubernetes" {
  # Configuration options
}

provider "argocd" {
  server_addr = "" # Dummy value required when using port_forward=true
  username    = "admin"
  password    = data.sops_file.argocd.data.argocdAdminPassword

  port_forward                = true
  port_forward_with_namespace = kubernetes_namespace.argocd.metadata.0.name

  plain_text = true
  # grpc_web = true
}
