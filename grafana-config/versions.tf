terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.10.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "3.25.9"
    }
  }
  required_version = ">= 1.10"
}
