module "tower_kv" {
  source = "github.com/Coalfire-CF/ACE-Azure-KeyVault"

  kv_name                         = "${local.resource_prefix}-twr-kv"
  resource_group_name             = data.terraform_remote_state.setup.outputs.key_vault_rg_name
  location                        = var.location
  tenant_id                       = var.tenant_id
  enabled_for_disk_encryption     = false
  enabled_for_deployment          = false
  enabled_for_template_deployment = true
  regional_tags                   = var.regional_tags
  global_tags                     = merge(var.global_tags, local.global_local_tags)
  diag_log_analytics_id           = data.terraform_remote_state.core.outputs.core_la_id
  tags = {
    Plane = "Management"
  }
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    virtual_network_subnet_ids = concat(
      values(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_vnet_subnet_ids),
      local.app_subnet_ids
    )
    ip_rules = var.cidrs_for_remote_access
  }
}
