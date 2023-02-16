resource "argocd_application" "app_of_apps" {
  metadata {
    name      = "k8s-gitops-services"
    namespace = kubernetes_namespace.argocd.metadata.0.name
  }

  spec {
    project                = argocd_project.base.metadata[0].name
    revision_history_limit = 0

    source {
      repo_url        = "git@github.com:mkilchhofer/k8s-gitops-services.git"
      path            = "argocd"
      target_revision = "main"
      directory {
        recurse = true
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }

    sync_policy {
      automated = {
        prune       = false
        self_heal   = false
        allow_empty = false
      }
    }

    info {
      name  = "Owner"
      value = "https://github.com/mkilchhofer/"
    }

  }
  cascade = false

  depends_on = [helm_release.argocd]
}
