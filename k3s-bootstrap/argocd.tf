data "akeyless_static_secret" "argocd" {
  path = "/k3s/argocd/credentials"
}

data "akeyless_static_secret" "argocd_gh_deploy_key" {
  path = "/k3s/argocd/github_deploy_key"
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = local.argocd_namespace
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
    plain    = data.akeyless_static_secret.argocd.key_value_pairs["admin_password"]
    hash     = bcrypt(data.akeyless_static_secret.argocd.key_value_pairs["admin_password"])
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
  version    = "9.2.1"
  namespace  = kubernetes_namespace_v1.argocd.metadata.0.name

  max_history = local.helm_max_history

  values = [
    file("${path.module}/helm-values/argocd.yaml")
  ]

  set_sensitive = [
    {
      name  = "configs.secret.argocdServerAdminPasswordMtime"
      value = null_resource.argocd_password.triggers.modified
    },
    {
      name  = "configs.secret.argocdServerAdminPassword"
      value = null_resource.argocd_password.triggers.hash
    },

    {
      name  = "configs.secret.extra.oidc\\.dex\\.clientSecret"
      value = data.akeyless_static_secret.argocd.key_value_pairs["oidc_client_secret"]
    },

    {
      name  = "notifications.secret.items.telegram-token"
      value = data.akeyless_static_secret.argocd.key_value_pairs["telegram_token"]
    },

    {
      name  = "configs.credentialTemplates.gh-mkilchhofer-ssh.sshPrivateKey"
      value = data.akeyless_static_secret.argocd_gh_deploy_key.value
    },

    {
      name  = "configs.credentialTemplates.internal-mkilchhofer-ssh.sshPrivateKey"
      value = data.akeyless_static_secret.argocd_gh_deploy_key.value
    }
  ]

  set = [
    # TLS for server
    {
      name  = "server.certificateSecret.crt"
      value = tls_locally_signed_cert.argocd_server.cert_pem
    },
    {
      name  = "server.certificateSecret.key"
      value = tls_private_key.argocd_server.private_key_pem
    },

    # TLS for repo-server
    {
      name  = "repoServer.certificateSecret.ca"
      value = tls_self_signed_cert.cilium_ca.cert_pem
    },
    {
      name  = "repoServer.certificateSecret.crt"
      value = tls_locally_signed_cert.argocd_repo_server.cert_pem
    },
    {
      name  = "repoServer.certificateSecret.key"
      value = tls_private_key.argocd_repo_server.private_key_pem
    }
  ]

  depends_on = [
    helm_release.cilium,
    helm_release.cilium_global_policies
  ]
}
