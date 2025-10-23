terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.11.1"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "4.12.0"
    }
  }
  required_version = ">= 1.10"
}
