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

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.10.5"
  namespace  = kubernetes_namespace.argocd.metadata.0.name

  values = [
    file("${path.module}/helm-values/argocd.yaml")
  ]

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = data.sops_file.argocd.data.argocdAdminPassword
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
}
