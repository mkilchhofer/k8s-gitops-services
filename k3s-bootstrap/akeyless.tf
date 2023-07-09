resource "akeyless_auth_method_api_key" "k3s_eso" {
  name = "k3s-eso"
}

resource "akeyless_role" "k3s_eso" {
  name = "k3s-eso"

  assoc_auth_method {
    am_name = akeyless_auth_method_api_key.k3s_eso.name
  }

  rules {
    capability = ["read"]
    path       = "/k3s/*"
    rule_type  = "item-rule"
  }
}
