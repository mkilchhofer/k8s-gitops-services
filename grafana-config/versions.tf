terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.7.5"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "3.15.3"
    }
  }
  required_version = ">= 1.3"
}
