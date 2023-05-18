terraform {
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "3.2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}
