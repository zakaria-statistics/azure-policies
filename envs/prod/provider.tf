terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

provider "azurerm" {
  alias   = "bootstrap"
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  use_cli         = true
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = local.terraform_client_secret
  tenant_id       = var.tenant_id
}
