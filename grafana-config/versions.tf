terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "2.0.1"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "4.28.2"
    }
  }
  required_version = ">= 1.10"
}
