terraform {
  required_version = "~>1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.61.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.39.0"
    }
  }

  # Backend commented out for the initial deploy. Uncomment to migrate state

  # backend "azurerm" {
  #   resource_group_name  = "ex-prod-va-mp-core-rg"
  #   storage_account_name = "exprodvampsatfstate"
  #   container_name       = "vaextfstatecontainer"
  #   environment          = "usgovernment"
  #   key                  = "va-security-core.tfstate"
  # }
}
