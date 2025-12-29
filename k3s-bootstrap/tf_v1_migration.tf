removed {
  from = kubernetes_namespace.argocd

  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_namespace_v1.argocd
  id = "argocd"
}
