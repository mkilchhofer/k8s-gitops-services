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
