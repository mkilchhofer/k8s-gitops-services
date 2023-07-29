locals {
  cilium_cluster_name = "default"
  hubble_server_cn    = "*.${local.cilium_cluster_name}.hubble-grpc.cilium.io"
  hubble_relay_cn     = "*.hubble-relay.cilium.io"
  hubble_ui_cn        = "*.hubble-ui.cilium.io"
  ca_validity_days    = 365
  certs_validity_days = 365
  rotation_days       = 60
}

###############################
# Cert rotation
###############################
resource "time_rotating" "rotate" {
  rotation_days = local.rotation_days
}

resource "time_static" "rotate" {
  rfc3339 = time_rotating.rotate.rfc3339
}

###############################
# CA
###############################
resource "tls_private_key" "cilium_ca" {
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    replace_triggered_by = [
      time_static.rotate
    ]
  }
}

resource "tls_self_signed_cert" "cilium_ca" {
  private_key_pem = tls_private_key.cilium_ca.private_key_pem

  is_ca_certificate = true

  subject {
    country     = "CH"
    common_name = "K3s Cilium CA"
  }

  validity_period_hours = local.ca_validity_days * 24

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    # "cert_signing",
    "server_auth",
    "client_auth",
  ]
}

###############################
# Hubble Server
###############################
resource "tls_private_key" "hubble_server" {
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    replace_triggered_by = [
      time_static.rotate
    ]
  }
}

resource "tls_cert_request" "hubble_server" {
  private_key_pem = tls_private_key.hubble_server.private_key_pem

  subject {
    common_name = local.hubble_server_cn
  }
  dns_names = [local.hubble_server_cn]
}

resource "tls_locally_signed_cert" "hubble_server" {
  cert_request_pem   = tls_cert_request.hubble_server.cert_request_pem
  ca_private_key_pem = tls_private_key.cilium_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.cilium_ca.cert_pem

  validity_period_hours = local.certs_validity_days * 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

###############################
# Hubble Relay
###############################
resource "tls_private_key" "hubble_relay" {
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    replace_triggered_by = [
      time_static.rotate
    ]
  }
}

resource "tls_cert_request" "hubble_relay" {
  private_key_pem = tls_private_key.hubble_relay.private_key_pem

  subject {
    common_name = local.hubble_relay_cn
  }
  dns_names = [local.hubble_relay_cn]
}

resource "tls_locally_signed_cert" "hubble_relay" {
  cert_request_pem   = tls_cert_request.hubble_relay.cert_request_pem
  ca_private_key_pem = tls_private_key.cilium_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.cilium_ca.cert_pem

  validity_period_hours = local.certs_validity_days * 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

###############################
# Hubble UI
###############################
resource "tls_private_key" "hubble_ui" {
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    replace_triggered_by = [
      time_static.rotate
    ]
  }
}

resource "tls_cert_request" "hubble_ui" {
  private_key_pem = tls_private_key.hubble_ui.private_key_pem

  subject {
    common_name = local.hubble_ui_cn
  }
  dns_names = [local.hubble_ui_cn]
}

resource "tls_locally_signed_cert" "hubble_ui" {
  cert_request_pem   = tls_cert_request.hubble_ui.cert_request_pem
  ca_private_key_pem = tls_private_key.cilium_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.cilium_ca.cert_pem

  validity_period_hours = local.certs_validity_days * 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

resource "kubernetes_secret_v1" "hubble_ui" {
  metadata {
    name      = "hubble-ui-custom"
    namespace = "kube-system"
  }

  data = {
    "ca.crt"  = tls_self_signed_cert.cilium_ca.cert_pem
    "tls.crt" = tls_locally_signed_cert.hubble_ui.cert_pem
    "tls.key" = tls_private_key.hubble_ui.private_key_pem
  }
}
