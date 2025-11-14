locals {
  helm_max_history = 3

  # Cluster credentials
  kubernetes_client_certificate     = base64decode(data.akeyless_static_secret.cluster_credentials.key_value_pairs["client-certificate-data"])
  kubernetes_client_key             = base64decode(data.akeyless_static_secret.cluster_credentials.key_value_pairs["client-key-data"])
  kubernetes_cluster_ca_certificate = base64decode(data.akeyless_static_secret.cluster_credentials.key_value_pairs["certificate-authority-data"])
}

data "akeyless_static_secret" "cluster_credentials" {
  path = "/k3s/cluster-admin-creds"
}
