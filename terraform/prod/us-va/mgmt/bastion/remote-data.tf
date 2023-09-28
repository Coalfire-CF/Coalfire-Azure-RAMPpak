## ### Core ###

data "terraform_remote_state" "core" {
  backend = "azurerm"
  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-security-core.tfstate"
  }
}

data "terraform_remote_state" "mgmt_naming" {
  backend = "azurerm"
  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-mgmt-naming.tfstate"
  }
}

data "terraform_remote_state" "app_naming" {
  backend = "azurerm"
  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-app-naming.tfstate"
  }
}


# ### Primary Region ###

data "terraform_remote_state" "setup" {
  backend = "azurerm"

  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-region-setup.tfstate"
  }
}

data "terraform_remote_state" "container-registry" {
  backend = "azurerm"

  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-container-registry.tfstate"
  }
}

data "terraform_remote_state" "usgv_mgmt_vnet" {
  backend = "azurerm"
  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-mgmt-network.tfstate"
  }
}

data "terraform_remote_state" "usgv_secured-vhub" {
  backend = "azurerm"
  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-secured-vhub.tfstate"
  }
}
#
#data "terraform_remote_state" "usgv_app_vnet" {
#  backend = "azurerm"
#  config  = {
#    storage_account_name = "${local.storage_name_prefix}satfstate"
#    resource_group_name  = "${local.resource_prefix_app}-common-rg"
#    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
#    environment          = "usgovernment"
#    key                  = "${var.location_abbreviation}-app-network.tfstate"
#  }
#}

data "terraform_remote_state" "usgv_az_automation" {
  backend = "azurerm"

  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-az-automation.tfstate"
  }
}

#data "terraform_remote_state" "usgv_az_packer_automation" {
#  backend = "azurerm"
#
#  config = {
#    storage_account_name = "stgmgmtvatestsatfstate"
#    resource_group_name  = "${local.resource_prefix_app}-common-rg"
#    container_name       = "vam43-govtfstatecontainer"
#    environment          = "usgovernment"
#    key                  = "${var.location_abbreviation}-az-packer-automation.tfstate"
#  }
#}

data "terraform_remote_state" "usgv_key_vaults" {
  backend = "azurerm"

  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-keyvault.tfstate"
  }
}

data "terraform_remote_state" "usgv-ad" {
  backend = "azurerm"
  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-ad.tfstate"
  }
}


data "terraform_remote_state" "usgv_ad_aa" {
  backend = "azurerm"

  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-ad-aa.tfstate"
  }
}

data "terraform_remote_state" "usgv_ad_connect" {
  backend = "azurerm"

  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-ad-connect.tfstate"
  }
}

data "terraform_remote_state" "usgv_backup" {
  backend = "azurerm"

  config = {
    storage_account_name = "stgmgmtvasatfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-backup.tfstate"
  }
}

data "terraform_remote_state" "usgv-bastion" {
  backend = "azurerm"
  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-bastion.tfstate"
  }
}
#
## # data "terraform_remote_state" "usgv_app_gateway" {
## #   backend = "azurerm"
#
## #   config = {
## #     storage_account_name = "usgvmp${var.app_abbreviation}satfstate"
## #     resource_group_name  = "usgv-mp-${var.app_abbreviation}-core-rg"
## #     container_name       = "usgv${var.app_abbreviation}tfstatecontainer"
## #     environment          = "public"
## #     key                  = "usgv-app-gateway.tfstate"
## #   }
## # }
#
## # data "terraform_remote_state" "usgv_traffic_manager" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "usgv-traffic-manager.tfstate"
## #   }
## # }
#
data "terraform_remote_state" "usgv_ca" {
  backend = "azurerm"
  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix_mgmt}-common-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-ca.tfstate"
  }
}
#
## # data "terraform_remote_state" "usgv_dsm" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "usgv-dsm.tfstate"
## #   }
## # }
#
## # data "terraform_remote_state" "usgv_elk" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "usgv-elk.tfstate"
## #   }
## # }
#
## # data "terraform_remote_state" "usgv_gitlab" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "usgv-gitlab.tfstate"
## #   }
## # }
#
## # data "terraform_remote_state" "usgv_nessus_burp" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "usgv-nessus-burp.tfstate"
## #   }
## # }
#
## # data "terraform_remote_state" "usgv_tower" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "usgv-tower.tfstate"
## #   }
## # }
#
## ### Secondary Region ###
#
#
## # data "terraform_remote_state" "ussc_setup" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "ussc-tfsetup.tfstate"
## #   }
## # }
#
## # data "terraform_remote_state" "ussc_app_vnet" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "ussc-app-network.tfstate"
## #   }
## # }
#
## # data "terraform_remote_state" "ussc_mgmt_vnet" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "ussc-mgmt-network.tfstate"
## #   }
## # }
#
## # data "terraform_remote_state" "ussc_vnet_peering" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "ussc-vnet-peering.tfstate"
## #   }
## # }
#
#
## # data "terraform_remote_state" "ussc_app_gateway" {
## #   backend = "azurerm"
#
## #   config = {
## # storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
## # resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
## # container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
## # environment          = "usgovernment"
## #     key                  = "ussc-app-gateway.tfstate"
## #   }
## # }

