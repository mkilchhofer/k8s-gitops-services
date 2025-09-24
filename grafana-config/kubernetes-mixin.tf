resource "grafana_folder" "kubernetes_mixin" {
  title = "Kubernetes"
}

module "kubernetes_mixin_alerts" {
  source  = "swisspost/prometheus-alerts/grafana"
  version = "~> 1.0"

  prometheus_alerts_file_path = file("./kubernetes-mixin/alerts.yaml")
  folder_uid                  = grafana_folder.kubernetes_mixin.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid

  # Decrease relative time range (seconds) for alert evaluation window to 1 minute
  # Ref: https://github.com/mkilchhofer/terraform-grafana-prometheus-alerts/issues/11
  alert_relative_time_range_from = 60

  overrides = {
    # Disable several alerts since we use K3s here
    KubeAPIDown = {
      is_paused = true
    }
    KubeControllerManagerDown = {
      is_paused = true
    }
    KubeProxyDown = {
      is_paused = true
    }
    KubeletDown = {
      is_paused = true
    }
    KubeSchedulerDown = {
      is_paused = true
    }
  }
}

resource "grafana_dashboard" "kubernetes_mixin" {
  for_each = fileset("./kubernetes-mixin/dashboards", "*.json")

  config_json = file("./kubernetes-mixin/dashboards/${each.key}")
  folder      = grafana_folder.kubernetes_mixin.id
}
