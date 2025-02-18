resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  lifecycle {
    ignore_changes = [
      metadata.0.annotations["cattle.io/status"],
      metadata.0.annotations["field.cattle.io/projectId"],
      metadata.0.annotations["lifecycle.cattle.io/create.namespace-auth"],
      metadata.0.annotations["management.cattle.io/no-default-sa-token"],
      metadata.0.labels["field.cattle.io/projectId"],
    ]
  }
}

resource "null_resource" "argocd_password" {
  triggers = {
    plain    = var.argocd_admin_password
    hash     = bcrypt(var.argocd_admin_password)
    modified = timestamp()
  }

  lifecycle {
    ignore_changes = [
      triggers["hash"],
      triggers["modified"]
    ]
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "oci://ghcr.io/argoproj/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.2"
  namespace  = kubernetes_namespace.argocd.metadata.0.name

  max_history = local.helm_max_history

  values = [
    file("${path.module}/helm-values/argocd.yaml")
  ]

  set {
    name  = "configs.secret.argocdServerAdminPasswordMtime"
    value = null_resource.argocd_password.triggers.modified
  }

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = null_resource.argocd_password.triggers.hash
  }

  set_sensitive {
    name  = "configs.secret.extra.oidc\\.dex\\.clientSecret"
    value = var.argocd_oidc_client_secret
  }

  set_sensitive {
    name  = "notifications.secret.items.telegram-token"
    value = var.telegram_token
  }

  set_sensitive {
    name  = "configs.credentialTemplates.gh-mkilchhofer-ssh.sshPrivateKey"
    value = var.argocd_github_deploy_key
  }

  set_sensitive {
    name  = "configs.credentialTemplates.internal-mkilchhofer-ssh.sshPrivateKey"
    value = var.argocd_github_deploy_key
  }

  # TLS for server
  set {
    name = "server.certificateSecret.crt"
    value = tls_locally_signed_cert.argocd_server.cert_pem
  }
  set {
    name = "server.certificateSecret.key"
    value = tls_private_key.argocd_server.private_key_pem
  }

  # TLS for repo-server
  set {
    name = "repoServer.certificateSecret.ca"
    value = tls_self_signed_cert.cilium_ca.cert_pem
  }
  set {
    name = "repoServer.certificateSecret.crt"
    value = tls_locally_signed_cert.argocd_repo_server.cert_pem
  }
  set {
    name = "repoServer.certificateSecret.key"
    value = tls_private_key.argocd_repo_server.private_key_pem
  }

  depends_on = [
    helm_release.cilium,
    helm_release.cilium_global_policies
  ]
}
