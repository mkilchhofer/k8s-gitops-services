provider "helm" {
  # Configuration options
}
provider "kubernetes" {
  # Configuration options
}

provider "argocd" {
  server_addr = "port-forward"
  username    = "admin"

  port_forward                = true
  port_forward_with_namespace = "argocd"

  plain_text = true
  # grpc_web = true
}
