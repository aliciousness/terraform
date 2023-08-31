# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstateRG01"
    storage_account_name = "tfstate01136"  # Output from make_state_storage.sh
    container_name       = "tfstate"
    key                  = "homer.tfstate"
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

}