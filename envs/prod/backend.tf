terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-vault-prod"
    storage_account_name = "tfstateprodne5678"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate" # blob name inside container
  }
}
