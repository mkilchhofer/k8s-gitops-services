terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.11.4"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.12.5"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.2.1"
    }
  }
  required_version = ">= 1.10"
}
