variable "subscription_id" {
  description = "Azure subscription hosting the shared infrastructure."
  type        = string
}

variable "client_id" {
  description = "Service principal application (client) ID."
  type        = string
}

variable "client_secret" {
  description = "Service principal secret."
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure AD tenant ID."
  type        = string
}

variable "sp_object_id" {
  description = "Object ID of the Terraform service principal that needs Key Vault access."
  type        = string
}

variable "default_tags" {
  description = "Tags applied to all bootstrap resources."
  type        = map(string)
  default     = {}
}

variable "environments" {
  description = "Per-environment configuration for remote state storage and Key Vaults."
  type = map(object({
    location             = string
    resource_group_name  = string
    storage_account_name = string
    container_name       = string
    key_vault_name       = string
    state_key            = optional(string)
    tags                 = optional(map(string))
  }))
}
