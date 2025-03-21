module "setup" {
  source = "github.com/Coalfire-CF/ACE-Azure-RegionSetup?ref=v1.0.5"

  location_abbreviation = var.location_abbreviation
  location              = var.location
  resource_prefix       = local.resource_prefix
  app_abbreviation      = var.app_abbreviation
  regional_tags         = var.regional_tags
  global_tags           = merge(var.global_tags, local.global_local_tags)
  mgmt_rg_name          = "${local.resource_prefix}-management-rg"
  app_rg_name           = "${local.resource_prefix}-application-rg"
  key_vault_rg_name     = "${local.resource_prefix}-keyvault-rg"
  networking_rg_name    = "${local.resource_prefix}-networking-rg"
  sas_start_date        = "2025-03-11" # Today's date
  sas_end_date          = "2025-06-11" # 3 months from today
  ip_for_remote_access  = var.ip_for_remote_access
  core_kv_id            = data.terraform_remote_state.core.outputs.core_kv_id
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id

  # uncomment the following line when the mgmt-network is created
  #firewall_vnet_subnet_ids = values(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_vnet_subnet_ids) #Uncomment and rerun terraform apply after the mgmt-network is created

  additional_resource_groups = [
    "${local.resource_prefix}-identity-rg"
  ]
}
