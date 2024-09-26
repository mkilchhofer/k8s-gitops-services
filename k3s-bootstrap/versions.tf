terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.7.4"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "6.1.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
  required_version = ">= 1.3"
}
