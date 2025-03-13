module "setup" {
  source                     = "github.com/Coalfire-CF/ACE-Azure-RegionSetup?ref=v1.0.2"
  location_abbreviation      = var.location_abbreviation
  location                   = var.location
  resource_prefix            = local.resource_prefix
  app_abbreviation           = var.app_abbreviation
  regional_tags              = var.regional_tags
  global_tags                = merge(var.global_tags, local.global_local_tags)
  mgmt_rg_name               = "${local.resource_prefix}-management-rg"
  app_rg_name                = "${local.resource_prefix}-application-rg"
  key_vault_rg_name          = "${local.resource_prefix}-keyvault-rg"
  networking_rg_name         = "${local.resource_prefix}-networking-rg"
  additional_resource_groups = []
  sas_start_date             = "2025-03-11" # Today's date
  sas_end_date               = "2026-03-11" # 12 months from today
  ip_for_remote_access       = var.ip_for_remote_access
  core_kv_id                 = data.terraform_remote_state.core.outputs.core_kv_id
  diag_log_analytics_id      = data.terraform_remote_state.core.outputs.core_la_id

  # Optional custom resource names
  # Uncomment these to apply a custom naming convention
  # compute_gallery_name           = ""
  # cloudshell_storageaccount_name = ""
  # ars_storageaccount_name        = ""
  # docs_storageaccount_name       = ""
  # flowlogs_storageaccount_name   = ""
  # installs_storageaccount_name   = ""
  # vmdiag_storageaccount_name     = ""
  # network_watcher_name           = ""


  # uncomment the following line when the mgmt-network is created
  #firewall_vnet_subnet_ids = values(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_vnet_subnet_ids) #Uncomment and rerun terraform apply after the mgmt-network is created

}
