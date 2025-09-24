terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.10.4"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "4.9.0"
    }
  }
  required_version = ">= 1.10"
}
