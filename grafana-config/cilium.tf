resource "grafana_folder" "cilium" {
  title = "Cilium"
}

module "cilium_alerts" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts?ref=main"

  prometheus_alerts_file_path = file("./cilium/alerts.yaml")
  folder_uid                  = grafana_folder.cilium.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid
}

resource "grafana_dashboard" "cilium" {
  for_each = fileset("./cilium/dashboards", "*.json")

  config_json = file("./cilium/dashboards/${each.key}")
  folder      = grafana_folder.cilium.id
}
