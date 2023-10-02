module "win_bastion_nsg" {
  source = "github.com/Coalfire-CF/terraform-azurerm-nsg?ref=OC"

  location                          = var.location
  resource_group_name               = data.terraform_remote_state.setup.outputs.network_rg_name
  security_group_name               = "${local.vm_name_prefix}-winbastion"
  storage_account_flowlogs_id       = data.terraform_remote_state.setup.outputs.storage_account_flowlogs_id
  network_watcher_name              = data.terraform_remote_state.setup.outputs.network_watcher_name
  network_watcher_flow_log_name     = "${data.terraform_remote_state.setup.outputs.network_watcher_name}-windowsbastionflowlogs"
  network_watcher_flow_log_location = var.location
  diag_log_analytics_id             = data.terraform_remote_state.core.outputs.core_la_id
  diag_log_analytics_workspace_id   = data.terraform_remote_state.core.outputs.core_la_workspace_id

  regional_tags = var.regional_tags
  global_tags   = var.global_tags

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
    }
  ]
}
