
terraform {
  required_version = "1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "df-prod-va-mp-core-rg"
    storage_account_name = "dfprodvampsatfstate"
    container_name       = "vadftfstatecontainer"
    environment          = "usgovernment"
    key                  = "va-mgmt-k8s.tfstate"
  }
}