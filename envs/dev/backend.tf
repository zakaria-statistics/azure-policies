terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-vault-dev"
    storage_account_name = "tfstatedevwe1234"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate" # blob name inside container
  }
}
