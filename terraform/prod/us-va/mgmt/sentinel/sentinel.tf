module "sentinel" {
  source = "github.com/Coalfire-CF/terraform-azurerm-sentinel"

  name                         = "${local.resource_prefix}-sentinel"
  resource_group_name          = data.terraform_remote_state.setup.outputs.management_rg_name
  location                     = var.location
  log_analytics_workspace_id   = data.terraform_remote_state.core.outputs.core_la_workspace_id
  log_analytics_workspace_name = data.terraform_remote_state.core.outputs.core_la_workspace_name

  global_tags = var.global_tags
  regional_tags = merge({
    Function    = "SEIM"
    Plane       = "Management"
    Environment = "Production"
  }, var.regional_tags, local.global_local_tags)
}

