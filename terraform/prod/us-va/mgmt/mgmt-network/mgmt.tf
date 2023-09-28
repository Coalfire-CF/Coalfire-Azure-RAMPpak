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
  source              = "github.com/Coalfire-CF/ACE-Azure-Vnet?ref=module"
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
  # storage_account_flowlogs_id     = data.terraform_remote_state.setup.outputs.storage_account_flowlogs_id
  #network_watcher_name            = data.terraform_remote_state.setup.outputs.network_watcher_name

  #Attach Vnet to Private DNS zone
  private_dns_zone_id = data.terraform_remote_state.core.outputs.core_private_dns_zone_id.0

  #Note: DNS servers should be left to Azure default until the DC's are up. Otherwise the VM's will fail to get DNS to download scripts from storage accounts.
  #dns_servers   = concat(data.terraform_remote_state.usgv-ad.outputs.ad_dc1_ip, data.terraform_remote_state.usgv-ad.outputs.ad_dc2_ip)
  #regional_tags = var.regional_tags
  #global_tags   = merge(var.global_tags, local.global_local_tags)
  tags = {
    Function = "Networking"
    Plane    = "Management"
  }
}


# Commented out for now. Testing moving vbnet to module -DF
# Required for PSQL Flexible Servers
# module "psql-nsg" {
#   source = "../../../../modules/azurerm-network-security-group/"

#   resource_group_name             = data.terraform_remote_state.setup.outputs.network_rg_name
#   security_group_name             = "${local.resource_prefix}-psql-nsg"
#   location                        = var.location
#   storage_account_flowlogs_id     = data.terraform_remote_state.setup.outputs.storage_account_flowlogs_id
#   network_watcher_name            = data.terraform_remote_state.setup.outputs.network_watcher_name
#   network_watcher_flow_log_name   = "${local.resource_prefix}-psql-nfl"
#   global_tags                     = merge(var.global_tags, local.global_local_tags)
#   regional_tags                   = var.regional_tags
#   diag_log_analytics_id           = data.terraform_remote_state.core.outputs.core_la_id
#   diag_log_analytics_workspace_id = data.terraform_remote_state.core.outputs.core_la_workspace_id
#   nsg_tags = {
#     Function = "Database"
#     Plane    = "Management"
#   }

#   custom_rules = [
#     {
#       name                    = "PSQL"
#       priority                = "1000"
#       direction               = "Inbound"
#       access                  = "Allow"
#       protocol                = "Tcp"
#       destination_port_range  = "5432, 6432"
#       source_address_prefixes = [var.mgmt_network_cidr]
#       description             = "PSQL Access Ports"
#     },
#     {
#       access                     = "Allow"
#       description                = "AzureStorage"
#       destination_address_prefix = "Storage"
#       destination_port_range     = "*"
#       direction                  = "Inbound"
#       name                       = "AzureStorage"
#       priority                   = "2000"
#       protocol                   = "*"
#       source_address_prefixes    = [var.mgmt_network_cidr]
#       source_port_range          = "*"
#     }
#   ]
# }

# resource "azurerm_subnet_network_security_group_association" "psql" {
#   subnet_id                 = module.mgmt-vnet.vnet_subnets["${local.resource_prefix}-psql-sn-1"]
#   network_security_group_id = module.psql-nsg.network_security_group_id
# }
