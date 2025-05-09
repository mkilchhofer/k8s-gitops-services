terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.9.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "3.24.1"
    }
  }
  required_version = ">= 1.3"
}
