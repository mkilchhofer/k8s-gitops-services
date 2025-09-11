terraform {
  required_providers {
    akeyless = {
      source  = "akeyless-community/akeyless"
      version = "1.10.3"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "4.6.0"
    }
  }
  required_version = ">= 1.10"
}
