###############################
# Server
###############################
resource "tls_private_key" "argocd_server" {
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    replace_triggered_by = [
      time_static.rotate
    ]
  }
}

resource "tls_cert_request" "argocd_server" {
  private_key_pem = tls_private_key.argocd_server.private_key_pem

  subject {
    common_name = "argocd-server"
  }
  dns_names = [
    "argocd-server",
    "argocd-server.${kubernetes_namespace.argocd.metadata.0.name}.svc"
  ]
}

resource "tls_locally_signed_cert" "argocd_server" {
  cert_request_pem   = tls_cert_request.argocd_server.cert_request_pem
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
# Repo server
###############################
resource "tls_private_key" "argocd_repo_server" {
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    replace_triggered_by = [
      time_static.rotate
    ]
  }
}

resource "tls_cert_request" "argocd_repo_server" {
  private_key_pem = tls_private_key.argocd_repo_server.private_key_pem

  subject {
    common_name = "argocd-repo-server"
  }
  dns_names = [
    "argocd-repo-server",
    "argocd-repo-server.${kubernetes_namespace.argocd.metadata.0.name}.svc"
  ]
}

resource "tls_locally_signed_cert" "argocd_repo_server" {
  cert_request_pem   = tls_cert_request.argocd_repo_server.cert_request_pem
  ca_private_key_pem = tls_private_key.cilium_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.cilium_ca.cert_pem

  validity_period_hours = local.certs_validity_days * 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
