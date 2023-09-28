terraform {
  required_version = ">= 1.1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.91.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "use2-mp-tm-management-rg"
    storage_account_name = "use2mptmsatfstate"
    container_name       = "use2tmtfstatecontainer"
    environment          = "public"
    key                  = "ussc-mgmt-network.tfstate"
  }
}
