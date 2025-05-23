terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.9.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
  required_version = ">= 1.3"
}
