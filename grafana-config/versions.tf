terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.7.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "3.7.0"
    }
  }
  required_version = ">= 1.3"
}