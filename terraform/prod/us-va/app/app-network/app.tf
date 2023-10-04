module "subnet_addrs" {
  source          = "hashicorp/subnets/cidr"
  base_cidr_block = var.app_network_cidr
  networks = [
    {
      name     = "${local.resource_prefix}-dmz-sn-1"
      new_bits = 8
    },
    {
      name     = "${local.resource_prefix}-edge-sn-1"
      new_bits = 8
    },
    {
      name     = "${local.resource_prefix}-backend-sn-1"
      new_bits = 8
    },
  ]
}

module "app-vnet" {
  source              = "github.com/Coalfire-CF/terraform-azurerm-vnet"
  vnet_name           = "${local.resource_prefix}-app-vnet-1"
  resource_group_name = data.terraform_remote_state.setup.outputs.network_rg_name
  address_space       = [module.subnet_addrs.base_cidr_block]
  subnets = {
    "${local.resource_prefix}-dmz-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-dmz-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }
    "${local.resource_prefix}-edge-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-edge-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }
    "${local.resource_prefix}-backend-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-backend-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }
  }

  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id

  #Attach Vnet to Private DNS zone
  private_dns_zone_id = data.terraform_remote_state.core.outputs.core_private_dns_zone_id.0

  regional_tags = var.regional_tags
  global_tags   = var.global_tags
  tags = {
    Function = "Networking"
    Plane    = "Management"
  }
}

