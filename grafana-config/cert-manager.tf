resource "grafana_folder" "cert_manager" {
  title = "cert-manager"
}

module "cert_manager_alerts" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts?ref=main"

  prometheus_alerts_file_path = file("./cert-manager/alerts.yaml")
  folder_uid                  = grafana_folder.cert_manager.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid

  # Decrease relative time range (seconds) for alert evaluation window to 1 minute
  # Ref: https://github.com/mkilchhofer/terraform-grafana-prometheus-alerts/issues/11
  alert_relative_time_range_from = 60
}

resource "grafana_dashboard" "cert_manager" {
  for_each = fileset("./cert-manager/dashboards", "*.json")

  config_json = file("./cert-manager/dashboards/${each.key}")
  folder      = grafana_folder.cert_manager.id
}
