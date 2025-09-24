resource "grafana_folder" "cilium" {
  title = "Cilium"
}

module "cilium_alerts" {
  source  = "swisspost/prometheus-alerts/grafana"
  version = "~> 1.0"

  prometheus_alerts_file_path = file("./cilium/alerts.yaml")
  folder_uid                  = grafana_folder.cilium.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid

  # Decrease relative time range (seconds) for alert evaluation window to 1 minute
  # Ref: https://github.com/mkilchhofer/terraform-grafana-prometheus-alerts/issues/11
  alert_relative_time_range_from = 60
}

resource "grafana_dashboard" "cilium" {
  for_each = fileset("./cilium/dashboards", "*.json")

  config_json = file("./cilium/dashboards/${each.key}")
  folder      = grafana_folder.cilium.id
}
