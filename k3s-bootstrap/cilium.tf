resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.16.0" # also update in umbrella-charts/cilium-hubble-ui/Chart.yaml
  namespace  = "kube-system"

  max_history = local.helm_max_history

  # Ref: https://docs.cilium.io/en/stable/gettingstarted/hubble-configuration/#user-provided-certificates
  # --set hubble.tls.auto.enabled=false                          # disable automatic TLS certificate generation
  # --set-file hubble.tls.ca.cert=ca.crt.b64                     # certificate of the CA that signs all certificates
  # --set-file hubble.tls.server.cert=server.crt.b64             # certificate for Hubble server
  # --set-file hubble.tls.server.key=server.key.b64              # private key for the Hubble server certificate
  # --set-file hubble.relay.tls.client.cert=relay-client.crt.b64 # client certificate for Hubble Relay to connect to Hubble instances
  # --set-file hubble.relay.tls.client.key=relay-client.key.b64  # private key for Hubble Relay client certificate
  # --set-file hubble.relay.tls.server.cert=relay-server.crt.b64 # server certificate for Hubble Relay
  # --set-file hubble.relay.tls.server.key=relay-server.key.b64  # private key for Hubble Relay server certificate
  # --set-file hubble.ui.tls.client.cert=ui-client.crt.b64       # client certificate for Hubble UI
  # --set-file hubble.ui.tls.client.key=ui-client.key.b64        # private key for Hubble UI client certificate

  # CA
  # TODO: Remove "hubble.tls.ca.cert" on migration to 1.13
  # (check again in next release, still seems required in 1.13.9)
  set {
    name  = "tls.ca.cert"
    value = base64encode(tls_self_signed_cert.cilium_ca.cert_pem)
  }
  set {
    name  = "hubble.tls.ca.cert"
    value = base64encode(tls_self_signed_cert.cilium_ca.cert_pem)
  }

  # Hubble Server
  set {
    name  = "hubble.tls.server.cert"
    value = base64encode(tls_locally_signed_cert.hubble_server.cert_pem)
  }
  set {
    name  = "hubble.tls.server.key"
    value = base64encode(tls_private_key.hubble_server.private_key_pem)
  }

  # Hubble Relay
  set {
    name  = "hubble.relay.tls.client.cert"
    value = base64encode(tls_locally_signed_cert.hubble_relay.cert_pem)
  }
  set {
    name  = "hubble.relay.tls.client.key"
    value = base64encode(tls_private_key.hubble_relay.private_key_pem)
  }
  set {
    name  = "hubble.relay.tls.server.cert"
    value = base64encode(tls_locally_signed_cert.hubble_relay.cert_pem)
  }
  set {
    name  = "hubble.relay.tls.server.key"
    value = base64encode(tls_private_key.hubble_relay.private_key_pem)
  }

  # Use default chart values and merge them with customized ones in line below
  reset_values = true

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
