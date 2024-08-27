provider "akeyless" {
  api_gateway_address = "https://api.akeyless.io"

  api_key_login {
    access_id  = var.akeyless_access_id
    access_key = var.akeyless_access_key
  }
}

data "akeyless_secret" "grafana_creds" {
  path = "/k3s/grafana/admin-creds"
}

locals {
  grafana_auth = jsondecode(data.akeyless_secret.grafana_creds.value)
}

provider "grafana" {
  # Configuration options
  auth = "${local.grafana_auth["admin-user"]}:${local.grafana_auth["admin-password"]}"
  url  = "https://grafana.tools.kilchhofer.info"
}
