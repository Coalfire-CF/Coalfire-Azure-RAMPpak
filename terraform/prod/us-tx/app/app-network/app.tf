module "app-vnet" {
  source              = "../../../../modules/azurerm-vnet"
  vnet_name           = "${var.location_abbreviation}-ap-${var.app_abbreviation}-vnet-1"
  resource_group_name = data.terraform_remote_state.ussc-setup.outputs.network_rg_name
  address_space       = ["${var.ip_network_app}.0.0/16"]
  subnet_prefixes = ["${var.ip_network_app}.1.0/24",
    "${var.ip_network_app}.2.0/24",
  "${var.ip_network_app}.3.0/24"]

  subnet_names = ["${var.location_abbreviation}-ap-${var.app_abbreviation}-dmz-sn-1",
    "${var.location_abbreviation}-ap-${var.app_abbreviation}-edge-sn-1",
  "${var.location_abbreviation}-ap-${var.app_abbreviation}-backend-sn-1"]

  subnet_service_endpoints = {
    "${var.location_abbreviation}-ap-${var.app_abbreviation}-dmz-sn-1"     = ["Microsoft.KeyVault", "Microsoft.Storage"],
    "${var.location_abbreviation}-ap-${var.app_abbreviation}-edge-sn-1"    = ["Microsoft.KeyVault", "Microsoft.Storage"],
    "${var.location_abbreviation}-ap-${var.app_abbreviation}-backend-sn-1" = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }

  # Note: DNS servers should be left to Azure default until the DC's are up. Otherwise the VM's will fail to get DNS to download scripts from storage accounts.
  dns_servers   = concat(data.terraform_remote_state.ad.outputs.ad_dc1_ip, data.terraform_remote_state.ad.outputs.ad_dc2_ip)
  regional_tags = var.regional_tags
  global_tags   = var.global_tags
  tags = {
    Function = "Networking"
    Plane    = "Management"
  }
}


data "azurerm_monitor_diagnostic_categories" "diag_options" {
  resource_id = module.app-vnet.vnet_id
}

module "app_vnet_diag" {
  source                = "../../../../modules/coalfire-diagnostic"
  diag_name             = "app_vnet_diag"
  resource_id           = module.app-vnet.vnet_id
  diag_eventhub_auth_id = data.terraform_remote_state.ussc-setup.outputs.diag_eventhub_auth_id
  diag_eventhub_name    = data.terraform_remote_state.ussc-setup.outputs.diag_eventhub_name
  diag_logs             = data.azurerm_monitor_diagnostic_categories.diag_options.logs
  diag_metrics          = data.azurerm_monitor_diagnostic_categories.diag_options.metrics
}
