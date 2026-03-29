terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.11.6"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "4.28.2"
    }
  }
  required_version = ">= 1.10"
}
