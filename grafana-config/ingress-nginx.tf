resource "grafana_folder" "ingress_nginx" {
  title = "Ingress-Nginx Controller"
}

module "ingress_nginx_alerts" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts?ref=init"

  prometheus_alerts_file_path = file("./ingress-nginx/alerts.yaml")
  folder_uid                  = grafana_folder.ingress_nginx.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid
}

resource "grafana_dashboard" "ingress_nginx" {
  for_each = fileset("./ingress-nginx/dashboards", "*.json")

  config_json = file("./ingress-nginx/dashboards/${each.key}")
  folder      = grafana_folder.ingress_nginx.id
}
