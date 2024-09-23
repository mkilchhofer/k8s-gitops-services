resource "grafana_folder" "kubernetes_mixin" {
  title = "Kubernetes"
}

module "kubernetes_mixin_alerts" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts?ref=main"

  prometheus_alerts_file_path = file("./kubernetes-mixin/alerts.yaml")
  folder_uid                  = grafana_folder.kubernetes_mixin.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid
}

resource "grafana_dashboard" "kubernetes_mixin" {
  for_each = fileset("./kubernetes-mixin/dashboards", "*.json")

  config_json = file("./kubernetes-mixin/dashboards/${each.key}")
  folder      = grafana_folder.kubernetes_mixin.id
}
