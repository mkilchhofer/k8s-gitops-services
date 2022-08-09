resource "argocd_project" "base" {
  metadata {
    name      = "base"
    namespace = "argocd"
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
}

resource "argocd_project" "core_services_unrestricted" {
  metadata {
    name      = "core-services-unrestricted"
    namespace = "argocd"
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
}

resource "argocd_project" "apps_with_clusterroles" {
  metadata {
    name      = "apps-with-clusterroles"
    namespace = "argocd"
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
}

resource "argocd_project" "apps_restricted" {
  metadata {
    name      = "apps-restricted"
    namespace = "argocd"
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
}
