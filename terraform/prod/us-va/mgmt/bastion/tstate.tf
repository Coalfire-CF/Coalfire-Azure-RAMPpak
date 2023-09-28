terraform {
  required_version = "1.3.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.45.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "stg-mgmt-va-common-rg"
    storage_account_name = "stgmgmtvasatfstate"
    container_name       = "vam43govtfstatecontainer"
    environment          = "usgovernment"
    key                  = "va-bastion.tfstate"
  }
}
