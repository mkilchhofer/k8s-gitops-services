resource "grafana_folder" "keda" {
  title = "KEDA"
}

module "keda_alerts" {
  source  = "swisspost/prometheus-alerts/grafana"
  version = "~> 1.0"

  prometheus_alerts_file_path = file("./keda/alerts.yaml")
  folder_uid                  = grafana_folder.keda.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid
}

resource "grafana_dashboard" "keda" {
  for_each = fileset("./keda/dashboards", "*.json")

  config_json = file("./keda/dashboards/${each.key}")
  folder      = grafana_folder.keda.id
}
