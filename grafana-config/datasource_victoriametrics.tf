data "akeyless_secret" "victoria_metrics_creds" {
  path = "/k3s/victoria-metrics-vmsingle/grafana-datasource"
}

locals {
  victoria_metrics_creds = jsondecode(data.akeyless_secret.victoria_metrics_creds.value)
}

resource "grafana_data_source" "victoria_metrics" {
  name                = "VictoriaMetrics"
  type                = "prometheus"
  url                 = "https://vm.cloud.kilchhofer.info"
  basic_auth_enabled  = true
  basic_auth_username = local.victoria_metrics_creds["username"]
  secure_json_data_encoded = jsonencode({
    basicAuthPassword = local.victoria_metrics_creds["password"]
  })
  json_data_encoded = jsonencode({
    httpMethod = "POST"
  })
}
