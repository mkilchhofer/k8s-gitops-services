resource "grafana_folder" "coredns" {
  title = "CoreDNS"
}

module "coredns_alerts" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts?ref=main"

  prometheus_alerts_file_path = file("./coredns/alerts.yaml")
  folder_uid                  = grafana_folder.coredns.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid
}

resource "grafana_dashboard" "coredns" {
  for_each = fileset("./coredns/dashboards", "*.json")

  config_json = file("./coredns/dashboards/${each.key}")
  folder      = grafana_folder.coredns.id
}
