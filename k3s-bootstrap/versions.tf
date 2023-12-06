terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.3.2"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "6.0.3"
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
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
  required_version = ">= 1.3"
}
