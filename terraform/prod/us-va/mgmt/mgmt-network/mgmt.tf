module "subnet_addrs" {
  source          = "hashicorp/subnets/cidr"
  base_cidr_block = var.mgmt_network_cidr
  networks = [
    {
      name     = "${local.resource_prefix}-public-sn-1"
      new_bits = 8
    },
    {
      name     = "${local.resource_prefix}-iam-sn-1"
      new_bits = 8
    },
    {
      name     = "${local.resource_prefix}-cicd-sn-1"
      new_bits = 8
    },
    {
      name     = "${local.resource_prefix}-secops-sn-1"
      new_bits = 8
    },
    {
      name     = "${local.resource_prefix}-siem-sn-1"
      new_bits = 8
    },
    {
      name     = "${local.resource_prefix}-monitor-sn-1"
      new_bits = 8
    },
    {
      name     = "${local.resource_prefix}-bastion-sn-1"
      new_bits = 8
    },
    {
      name     = "AzureFirewallSubnet" #Per Azure docs, The Management Subnet used for the Firewall must have the name AzureFirewallManagementSubnet and the subnet mask must be at least a /26.
      new_bits = 8
    },
    {
      name     = "${local.resource_prefix}-pe-sn-1"
      new_bits = 8
    }
    ,
    {
      name     = "${local.resource_prefix}-psql-sn-1"
      new_bits = 8
    }
  ]
}

module "mgmt-vnet" {
  source              = "github.com/Coalfire-CF/terraform-azurerm-vnet"
  vnet_name           = "${local.resource_prefix}-network-vnet"
  resource_group_name = data.terraform_remote_state.setup.outputs.network_rg_name
  address_space       = [module.subnet_addrs.base_cidr_block]
  subnets = {
    "${local.resource_prefix}-public-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-public-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }

    "${local.resource_prefix}-iam-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-iam-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }

    "${local.resource_prefix}-cicd-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-cicd-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.ContainerRegistry"]
    }

    "${local.resource_prefix}-secops-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-secops-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }

    "${local.resource_prefix}-siem-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-siem-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }

    "${local.resource_prefix}-monitor-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-monitor-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }

    "${local.resource_prefix}-bastion-sn-1" = {
      address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-bastion-sn-1"]
      subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]

      "AzureFirewallSubnet" = {
        address_prefix           = module.subnet_addrs.network_cidr_blocks["AzureFirewallSubnet"]
        subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
      }

      "${local.resource_prefix}-pe-sn-1" = {
        address_prefix                                 = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-pe-sn-1"]
        subnet_service_endpoints                       = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql", "Microsoft.ContainerRegistry"]
        enforce_private_link_endpoint_network_policies = true
      }

      "${local.resource_prefix}-psql-sn-1" = {
        address_prefix           = module.subnet_addrs.network_cidr_blocks["${local.resource_prefix}-psql-sn-1"]
        subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"]
        subnet_delegations = {
          "Microsoft.DBforPostgreSQL/flexibleServers" = ["Microsoft.Sql"]
        }
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id

  #Attach Vnet to Private DNS zone
  private_dns_zone_id = data.terraform_remote_state.core.outputs.core_private_dns_zone_id.0

  tags = {
    Function = "Networking"
    Plane    = "Management"
  }
}

