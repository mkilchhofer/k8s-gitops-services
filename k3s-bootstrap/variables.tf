variable "argocd_admin_password" {
  type        = string
  sensitive   = true
  description = "Password of Argo CD admin user"
}

variable "argocd_github_deploy_key" {
  type        = string
  sensitive   = true
  description = "GitHub Deploy key (private key) for Argo CD"
}

variable "argocd_oidc_client_secret" {
  type        = string
  sensitive   = true
  description = "OIDC client secret for Argo CD SSO"
}

variable "telegram_token" {
  type        = string
  sensitive   = true
  description = "Telegram token for Argo CD notifications"
}

variable "kubernetes_cluster_ca_certificate" {
  type        = string
  description = "PEM-encoded root certificates bundle for TLS authentication."
}

variable "kubernetes_client_certificate" {
  type        = string
  sensitive   = true
  description = "PEM-encoded client certificate for TLS authentication."
}

variable "kubernetes_client_key" {
  type        = string
  sensitive   = true
  description = "PEM-encoded client certificate key for TLS authentication."
}

variable "doppler_service_token" {
  type        = string
  sensitive   = true
  description = "Doppler Service Token for ClusterSecretStore"
}

variable "akeyless_access_id" {
  type        = string
  sensitive   = true
  description = "Akeyless access ID to initialize terraform provider"
}

variable "akeyless_access_key" {
  type        = string
  sensitive   = true
  description = "Akeyless access key to initialize terraform provider"
}
