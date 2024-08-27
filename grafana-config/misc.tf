resource "grafana_folder" "misc" {
  title = "Miscellaneous"
}

resource "grafana_dashboard" "misc" {
  for_each = fileset("./misc/dashboards", "*.json")

  config_json = file("./misc/dashboards/${each.key}")
  folder      = grafana_folder.misc.id
}
