terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.8.2"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "3.18.3"
    }
  }
  required_version = ">= 1.3"
}
