### Core ###
# data "terraform_remote_state" "core" {
#   backend = "azurerm"
#   config = {
#     storage_account_name = "${local.storage_name_prefix}satfstate"
#     resource_group_name  = "${local.resource_prefix}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "${var.location_abbreviation}-security-core.tfstate"
#   }
# }

### Primary Region ###
# data "terraform_remote_state" "setup" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = "${local.storage_name_prefix}satfstate"
#     resource_group_name  = "${local.resource_prefix}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "${var.location_abbreviation}-region-setup.tfstate"
#   }
# }

# Uncomment these as needed

# data "terraform_remote_state" "usgv_mgmt_vnet" {
#   backend = "azurerm"
#   config = {
#     storage_account_name = "${local.storage_name_prefix}satfstate"
#     resource_group_name  = "${local.resource_prefix}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "${var.location_abbreviation}-mgmt-network.tfstate"
#   }
# }

# data "terraform_remote_state" "usgv_app_vnet" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = "${local.storage_name_prefix}satfstate"
#     resource_group_name  = "${local.resource_prefix}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "${var.location_abbreviation}-app-network.tfstate"
#   }
# }

# data "terraform_remote_state" "usgv_az_automation" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = "${local.storage_name_prefix}satfstate"
#     resource_group_name  = "${local.resource_prefix}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "${var.location_abbreviation}-az-automation.tfstate"
#   }
# }

# data "terraform_remote_state" "usgv_key_vaults" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = "${local.storage_name_prefix}satfstate"
#     resource_group_name  = "${local.resource_prefix}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "${var.location_abbreviation}-key-vault.tfstate"
#   }
# }


# data "terraform_remote_state" "usgv_aa" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = "${local.storage_name_prefix}satfstate"
#     resource_group_name  = "${local.resource_prefix}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "${var.location_abbreviation}-aa.tfstate"
#   }
# }

# data "terraform_remote_state" "usgv_backup" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = "${local.storage_name_prefix}satfstate"
#     resource_group_name  = "${local.resource_prefix}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "${var.location_abbreviation}-backup.tfstate"
#   }
# }

# data "terraform_remote_state" "usgv-bastion" {
#   backend = "azurerm"
#   config = {
#     storage_account_name = "${local.storage_name_prefix}satfstate"
#     resource_group_name  = "${local.resource_prefix}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "${var.location_abbreviation}-bastion.tfstate"
#   }
# }


### Secondary Region ###

# data "terraform_remote_state" "ussc_setup" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
#     resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "ussc-tfsetup.tfstate"
#   }
# }

# data "terraform_remote_state" "ussc_app_vnet" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
#     resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "ussc-app-network.tfstate"
#   }
# }

# data "terraform_remote_state" "ussc_mgmt_vnet" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
#     resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
#     container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#     environment          = var.az_environment
#     key                  = "ussc-mgmt-network.tfstate"
#   }
# }

