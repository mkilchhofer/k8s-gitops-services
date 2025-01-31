terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.8.1"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
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
