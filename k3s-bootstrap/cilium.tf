resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.12.7"
  namespace  = "kube-system"

  max_history = local.helm_max_history

  values = [
    file("${path.module}/helm-values/cilium.yaml")
  ]
}

resource "helm_release" "cilium_global_policies" {
  name       = "cilium-global-policies"
  chart      = "${path.module}/cilium-global-policies"
  namespace  = "kube-system"

  max_history = local.helm_max_history

  depends_on = [helm_release.cilium]
}
