resource "argocd_project" "base" {
  metadata {
    name      = "base"
    namespace = kubernetes_namespace.argocd.metadata.0.name
  }

  spec {
    description  = "Projects provisioned together with Argo CD (infra deployment)"
    source_repos = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }

    cluster_resource_whitelist {
      kind = "Namespace"
    }

    namespace_resource_whitelist {
      group = "argoproj.io"
      kind  = "Application"
    }
  }

  depends_on = [helm_release.argocd]
}

resource "argocd_project" "core_services_unrestricted" {
  metadata {
    name      = "core-services-unrestricted"
    namespace = kubernetes_namespace.argocd.metadata.0.name
  }

  spec {
    description  = "All unrestricted core-services"
    source_repos = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "*"
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }

  depends_on = [helm_release.argocd]
}

resource "argocd_project" "apps_with_clusterroles" {
  metadata {
    name      = "apps-with-clusterroles"
    namespace = kubernetes_namespace.argocd.metadata.0.name
  }

  spec {
    description  = "All apps with ClusterRoles and ClusterRoleBindings"
    source_repos = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "*"
    }

    # Deny all cluster-scoped resources from being created, except for Namespace, ClusterRole, ClusterRoleBinding
    cluster_resource_whitelist {
      kind = "Namespace"
    }
    cluster_resource_whitelist {
      group = "rbac.authorization.k8s.io"
      kind  = "ClusterRoleBinding"
    }
    cluster_resource_whitelist {
      group = "rbac.authorization.k8s.io"
      kind  = "ClusterRole"
    }


    # Allow all namespaced-scoped resources to be created, except for ResourceQuota, LimitRange
    namespace_resource_blacklist {
      kind = "ResourceQuota"
    }
    namespace_resource_blacklist {
      kind = "LimitRange"
    }
  }

  depends_on = [helm_release.argocd]
}

resource "argocd_project" "apps_restricted" {
  metadata {
    name      = "apps-restricted"
    namespace = kubernetes_namespace.argocd.metadata.0.name
  }

  spec {
    description  = "All restricted apps"
    source_repos = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "*"
    }

    # Deny all cluster-scoped resources from being created, except for Namespace, ClusterRole, ClusterRoleBinding
    cluster_resource_whitelist {
      kind = "Namespace"
    }

    # Allow all namespaced-scoped resources to be created, except for ResourceQuota, LimitRange
    namespace_resource_blacklist {
      kind = "ResourceQuota"
    }
    namespace_resource_blacklist {
      kind = "LimitRange"
    }
  }

  depends_on = [helm_release.argocd]
}
