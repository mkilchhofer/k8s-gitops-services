terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.7.5"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "3.11.0"
    }
  }
  required_version = ">= 1.3"
}
