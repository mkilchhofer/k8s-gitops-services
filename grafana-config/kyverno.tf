resource "grafana_folder" "kyverno" {
  title = "Kyverno"
}

module "kyverno_alerts" {
  source  = "swisspost/prometheus-alerts/grafana"
  version = "~> 1.0"

  prometheus_alerts_file_path = file("./kyverno/alerts.yaml")
  folder_uid                  = grafana_folder.kyverno.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid
}

resource "grafana_dashboard" "kyverno" {
  for_each = fileset("./kyverno/dashboards", "*.json")

  config_json = file("./kyverno/dashboards/${each.key}")
  folder      = grafana_folder.kyverno.id
}
