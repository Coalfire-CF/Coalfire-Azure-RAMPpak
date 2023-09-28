data "terraform_remote_state" "setup" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "tfsetup.tfstate"
  }
}

data "terraform_remote_state" "ussc-setup" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "ussc-tfsetup.tfstate"
  }
}

data "terraform_remote_state" "use2_mgmt_vnet" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "use2-mgmt-vnet.tfstate"
  }
}

data "terraform_remote_state" "use2_app_vnet" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "use2-app-vnet.tfstate"
  }
}

data "terraform_remote_state" "key_vaults" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "use2-keyvault.tfstate"
  }
}

data "terraform_remote_state" "ad" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "use2-ad.tfstate"
  }
}

data "terraform_remote_state" "backup" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "use2-backup.tfstate"
  }
}

data "terraform_remote_state" "use2_sql" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "use2-sql.tfstate"
  }
}

data "terraform_remote_state" "ussc_app_vnet" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "ussc-app-network.tfstate"
  }
}

data "terraform_remote_state" "ussc_mgmt_vnet" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "ussc-mgmt-network.tfstate"
  }
}

data "terraform_remote_state" "ussc_vnet_peering" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "ussc-vnet-peering.tfstate"
  }
}

data "terraform_remote_state" "ussc_sql" {
  backend = "azurerm"

  config = {
    storage_account_name = "use2mp${var.app_abbreviation}satfstate"
    resource_group_name  = "use2-mp-${var.app_abbreviation}-management-rg"
    container_name       = "use2${var.app_abbreviation}tfstatecontainer"
    environment          = "public"
    key                  = "ussc-sql.tfstate"
  }
}
