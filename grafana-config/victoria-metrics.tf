resource "grafana_folder" "victoria_metrics" {
  title = "VictoriaMetrics"
}

module "victoria_metrics_alerts" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts?ref=main"

  prometheus_alerts_file_path = file("./victoria-metrics/alerts.yaml")
  folder_uid                  = grafana_folder.victoria_metrics.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid
}

module "victoria_metrics_single_alerts" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts?ref=main"

  prometheus_alerts_file_path = file("./victoria-metrics/alerts-vmsingle.yaml")
  folder_uid                  = grafana_folder.victoria_metrics.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid
}

resource "grafana_dashboard" "victoria_metrics" {
  for_each = fileset("./victoria-metrics/dashboards", "*.json")

  config_json = file("./victoria-metrics/dashboards/${each.key}")
  folder      = grafana_folder.victoria_metrics.id
}
