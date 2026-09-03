terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "2.0.4"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.15.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.3.0"
    }
  }
  required_version = ">= 1.10"
}
