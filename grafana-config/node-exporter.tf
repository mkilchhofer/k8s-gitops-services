resource "grafana_folder" "node_exporter" {
  title = "Node exporter"
}

module "node_exporter_alerts" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts?ref=main"

  prometheus_alerts_file_path = file("./node_exporter/alerts.yaml")
  folder_uid                  = grafana_folder.node_exporter.uid

  # Data source to use
  datasource_uid = grafana_data_source.victoria_metrics.uid

  overrides = {
    NodeCPUHighUsage = {
      annotations = {
        "__dashboardUid__" = grafana_dashboard.node_exporter["nodes.json"].uid
        "__panelId__"      = "2"
      }
    }
    NodeFilesystemSpaceFillingUp-warning = {
      annotations = {
        "__dashboardUid__" = grafana_dashboard.node_exporter["nodes.json"].uid
        "__panelId__"      = "7"
      }
    }
    NodeFilesystemSpaceFillingUp-critical = {
      annotations = {
        "__dashboardUid__" = grafana_dashboard.node_exporter["nodes.json"].uid
        "__panelId__"      = "7"
      }
    }
    NodeSystemSaturation = {
      annotations = {
        "__dashboardUid__" = grafana_dashboard.node_exporter["nodes.json"].uid
        "__panelId__"      = "3"
      }
    }
    NodeDiskIOSaturation = {
      annotations = {
        "__dashboardUid__" = grafana_dashboard.node_exporter["nodes.json"].uid
        "__panelId__"      = "6"
      }
    }
    NodeMemoryHighUtilization = {
      annotations = {
        "__dashboardUid__" = grafana_dashboard.node_exporter["nodes.json"].uid
        "__panelId__"      = "4"
      }
    }
  }
}

resource "grafana_dashboard" "node_exporter" {
  for_each = fileset("./node_exporter/dashboards", "*.json")

  config_json = file("./node_exporter/dashboards/${each.key}")
  folder      = grafana_folder.node_exporter.id
}
