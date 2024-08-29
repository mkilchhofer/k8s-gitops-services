resource "grafana_folder" "node_exporter" {
  title = "Node exporter"
}

module "node_exporter_alerts" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts?ref=main"

  prometheus_alerts_file_path = file("./node_exporter/alerts.yaml")
  folder_uid                  = grafana_folder.node_exporter.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid
}

resource "grafana_dashboard" "node_exporter" {
  for_each = fileset("./node_exporter/dashboards", "*.json")

  config_json = file("./node_exporter/dashboards/${each.key}")
  folder      = grafana_folder.node_exporter.id
}
