resource "akeyless_auth_method_api_key" "k3s_eso" {
  name = "k3s-eso"
}

resource "akeyless_role" "k3s_eso" {
  name = "k3s-eso"

  rules {
    capability = ["read"]
    path       = "/k3s/*"
    rule_type  = "item-rule"
  }

  rules {
    capability = ["read"]
    path       = "/cloudflare-tunnels/*"
    rule_type  = "item-rule"
  }
}

resource "akeyless_associate_role_auth_method" "k3s_eso" {
  am_name   = akeyless_auth_method_api_key.k3s_eso.name
  role_name = akeyless_role.k3s_eso.name
}
