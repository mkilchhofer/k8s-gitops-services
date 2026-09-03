terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "2.0.4"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "4.38.0"
    }
  }
  required_version = ">= 1.10"
}
