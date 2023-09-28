locals {
  ip_network_mgmt = "10.0"
}

module "win_bastion_nsg" {
  source = "../../../../modules/azurerm-network-security-group/"

  location                          = var.location
  resource_group_name               = data.terraform_remote_state.core.outputs.core_rg_name
  security_group_name               = "${data.terraform_remote_state.mgmt_naming.outputs.network_security_group}-winbastion"
  storage_account_flowlogs_id       = data.terraform_remote_state.setup.outputs.storage_account_flowlogs_id
  network_watcher_name              = data.terraform_remote_state.setup.outputs.network_watcher_name
  network_watcher_flow_log_name     = "${data.terraform_remote_state.mgmt_naming.outputs.network_watcher}-windowsbastionflowlogs"
  network_watcher_flow_log_location = var.location
  regional_tags                     = var.regional_tags
  global_tags                       = var.global_tags
  diag_log_analytics_id             = data.terraform_remote_state.core.outputs.core_la_id
  diag_log_analytics_workspace_id   = data.terraform_remote_state.core.outputs.core_la_workspace_id

  custom_rules = [
    {

      name                    = "RDP"
      priority                = "100"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "3389"
      source_address_prefixes = var.cidrs_for_remote_access
      description             = "RDP"
    },
    {

      name                    = "HTTPS"
      priority                = "101"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "443"
      source_address_prefixes = var.cidrs_for_remote_access
      description             = "HTTPS"
    },
    {
      name                    = "AnsibleWindows"
      priority                = "1000"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "5985-5986"
      source_address_prefixes = ["${local.ip_network_mgmt}.3.0/24"]
      description             = "Ansible management port for windows VMs"
    },
    {
      name                    = "NessusWindows"
      priority                = "1100"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "139,445"
      source_address_prefixes = ["${local.ip_network_mgmt}.4.0/24"]
      description             = "Nessus Scan port for windows VMs"
    },
    {
      name                    = "DSM"
      priority                = "1200"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "4118"
      source_address_prefixes = ["${local.ip_network_mgmt}.4.0/24"]
      description             = "Trend DSM bidirectional port for windows VMs"
    }
  ]
}

module "lin_bastion_nsg" {
  source                            = "../../../../modules/azurerm-network-security-group/"
  location                          = var.location
  resource_group_name               = data.terraform_remote_state.core.outputs.core_rg_name
  security_group_name               = "${data.terraform_remote_state.mgmt_naming.outputs.network_security_group}-linbastion"
  storage_account_flowlogs_id       = data.terraform_remote_state.setup.outputs.storage_account_flowlogs_id
  network_watcher_name              = data.terraform_remote_state.setup.outputs.network_watcher_name
  network_watcher_flow_log_name     = "${data.terraform_remote_state.mgmt_naming.outputs.network_watcher}-linuxbastionflowlogs"
  network_watcher_flow_log_location = var.location
  regional_tags                     = var.regional_tags
  global_tags                       = var.global_tags
  diag_log_analytics_id             = data.terraform_remote_state.core.outputs.core_la_id
  diag_log_analytics_workspace_id   = data.terraform_remote_state.core.outputs.core_la_workspace_id


  custom_rules = [
    {
      name                    = "SSH"
      priority                = "100"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "22"
      source_address_prefixes = var.cidrs_for_remote_access
      description             = "SSH"
    },
    {
      name                    = "HTTPS"
      priority                = "101"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "443"
      source_address_prefixes = var.cidrs_for_remote_access
      description             = "HTTPS"
    },
    {
      name                    = "SSH2"
      priority                = "1000"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "22"
      source_address_prefixes = ["${local.ip_network_mgmt}.3.0/24", "${local.ip_network_mgmt}.4.0/24"]
      description             = "SSH Access for Ansible and Nessus"
    },
    {
      name                    = "DSM"
      priority                = "1100"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      destination_port_range  = "4118"
      source_address_prefixes = ["${local.ip_network_mgmt}.4.0/24"]
      description             = "Trend DSM bidirectional port for Linux VMs"
    }
  ]
}
