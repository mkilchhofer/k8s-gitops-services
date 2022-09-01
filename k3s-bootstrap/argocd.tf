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

data "sops_file" "argocd" {
  source_file = "../secrets/argocd.yaml"
}

resource "null_resource" "argocd_password" {
  triggers = {
    plain    = data.sops_file.argocd.data.argocdAdminPassword
    hash     = bcrypt(data.sops_file.argocd.data.argocdAdminPassword)
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
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.2.0"
  namespace  = kubernetes_namespace.argocd.metadata.0.name

  max_history = 3

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
    value = data.sops_file.argocd.data.oidcGithubClientSecret
  }

  set_sensitive {
    name  = "notifications.secret.items.telegram-token"
    value = data.sops_file.argocd.data.telegramToken
  }

  set_sensitive {
    name  = "configs.credentialTemplates.gh-mkilchhofer-ssh.sshPrivateKey"
    value = data.sops_file.argocd.data.sshPrivateKeyGit
  }

  set_sensitive {
    name  = "configs.credentialTemplates.internal-mkilchhofer-ssh.sshPrivateKey"
    value = data.sops_file.argocd.data.sshPrivateKeyGit
  }

  depends_on = [
    helm_release.cilium,
    helm_release.cilium_global_policies
  ]
}
