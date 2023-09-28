provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  environment     = var.az_environment
  alias           = "mgmt"
}

provider "azurerm" {
  features {}
  subscription_id = var.app_subscription_ids.awb
  tenant_id       = var.tenant_id
  environment     = var.az_environment
  alias           = "awb"
}

provider "azurerm" {
  features {}
  subscription_id = var.app_subscription_ids.sae
  tenant_id       = var.tenant_id
  environment     = var.az_environment
  alias           = "sae"
}

provider "azurerm" {
  features {}
  subscription_id = var.app_subscription_ids.spark
  tenant_id       = var.tenant_id
  environment     = var.az_environment
  alias           = "spark"
}

provider "azurerm" {
  features {}
  subscription_id = var.app_subscription_ids.v1platform
  tenant_id       = var.tenant_id
  environment     = var.az_environment
  alias           = "v1platform"
}

provider "azurerm" {
  features {}
  subscription_id = var.app_subscription_ids.ath
  tenant_id       = var.tenant_id
  environment     = var.az_environment
  alias           = "ath"
}

provider "azurerm" {
  features {}
  subscription_id = var.app_subscription_ids.psd
  tenant_id       = var.tenant_id
  environment     = var.az_environment
  alias           = "psd"
}

provider "azurerm" {
  features {}
  subscription_id = var.app_subscription_ids.sdl
  tenant_id       = var.tenant_id
  environment     = var.az_environment
  alias           = "sdl"
}

provider "azurerm" {
  features {}
  subscription_id = var.app_subscription_ids.edl
  tenant_id       = var.tenant_id
  environment     = var.az_environment
  alias           = "edl"
}