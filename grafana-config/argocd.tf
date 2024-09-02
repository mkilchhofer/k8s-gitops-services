resource "grafana_folder" "argocd" {
  title = "Argo CD"
}

module "argocd_alerts" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts?ref=main"

  prometheus_alerts_file_path = file("./argocd/alerts.yaml")
  folder_uid                  = grafana_folder.argocd.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid
}

resource "grafana_dashboard" "argocd" {
  for_each = fileset("./argocd/dashboards", "*.json")

  config_json = file("./argocd/dashboards/${each.key}")
  folder      = grafana_folder.argocd.id
}
