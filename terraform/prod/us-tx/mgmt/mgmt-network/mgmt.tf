module "mgmt-vnet" {
  source              = "../../../../modules/azurerm-vnet"
  vnet_name           = "${var.location_abbreviation}-mp-${var.app_abbreviation}-vnet-1"
  resource_group_name = data.terraform_remote_state.ussc-setup.outputs.network_rg_name
  location            = var.location
  address_space       = ["${var.ip_network_mgmt}.0.0/16"]
  subnet_prefixes = ["${var.ip_network_mgmt}.1.0/24",
    "${var.ip_network_mgmt}.2.0/24",
    "${var.ip_network_mgmt}.3.0/24",
    "${var.ip_network_mgmt}.4.0/24",
    "${var.ip_network_mgmt}.5.0/24",
    "${var.ip_network_mgmt}.6.0/24",
    "${var.ip_network_mgmt}.7.0/24",
  "${var.ip_network_mgmt}.8.0/24"]

  subnet_names = ["${var.location_abbreviation}-mp-${var.app_abbreviation}-public-sn-1", # "use2-mp-tm-public-sn-1"
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-iam-sn-1",
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-cicd-sn-1",
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-secops-sn-1",
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-siem-sn-1",
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-monitor-sn-1",
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-bastion-sn-1",
  "${var.location_abbreviation}-mp-${var.app_abbreviation}-inside-sn-1"]

  subnet_service_endpoints = {
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-public-sn-1"  = ["Microsoft.KeyVault"],
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-iam-sn-1"     = ["Microsoft.KeyVault", "Microsoft.Storage"],
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-cicd-sn-1"    = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"],
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-secops-sn-1"  = ["Microsoft.KeyVault", "Microsoft.Storage"],
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-siem-sn-1"    = ["Microsoft.KeyVault", "Microsoft.Storage"],
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-monitor-sn-1" = ["Microsoft.KeyVault", "Microsoft.Storage"],
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-bastion-sn-1" = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"],
    "${var.location_abbreviation}-mp-${var.app_abbreviation}-inside-sn-1"  = ["Microsoft.KeyVault", "Microsoft.Storage"]
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
  resource_id = module.mgmt-vnet.vnet_id
}
module "mgmt_vnet_diag" {
  source                = "../../../../modules/coalfire-diagnostic"
  diag_name             = "mgmt_vnet_diag"
  resource_id           = module.mgmt-vnet.vnet_id
  diag_eventhub_auth_id = data.terraform_remote_state.ussc-setup.outputs.diag_eventhub_auth_id
  diag_eventhub_name    = data.terraform_remote_state.ussc-setup.outputs.diag_eventhub_name
  diag_logs             = data.azurerm_monitor_diagnostic_categories.diag_options.logs
  diag_metrics          = data.azurerm_monitor_diagnostic_categories.diag_options.metrics
}
