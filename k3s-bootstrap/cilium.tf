resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.11.5"
  namespace  = "kube-system"

  values = [
    file("${path.module}/helm-values/cilium.yaml")
  ]
}

resource "helm_release" "cilium_global_policies" {
  name       = "cilium-global-policies"
  chart      = "${path.module}/cilium-global-policies"
  namespace  = "kube-system"

  depends_on = [helm_release.cilium]
}
