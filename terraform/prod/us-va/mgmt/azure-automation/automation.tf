# resource "azurerm_automation_account" "va-aa" {
#   name                = "${local.resource_prefix}-aa"
#   location            = var.location
#   resource_group_name = data.terraform_remote_state.setup.outputs.management_rg_name
#   sku_name            = "Basic"

#   identity {
#     type = "SystemAssigned"
#   }

#   tags = merge({
#     Function    = "Automation"
#     Plane       = "Management"
#     Environment = "Production"
#   }, var.global_tags, var.regional_tags, local.global_local_tags)
# }

# resource "azurerm_log_analytics_linked_service" "aa_la_link" {
#   resource_group_name = data.terraform_remote_state.core.outputs.core_rg_name
#   workspace_id        = data.terraform_remote_state.core.outputs.core_la_id
#   read_access_id      = azurerm_automation_account.va-aa.id
# }

module "va-aa" {
  source                     = "github.com/Coalfire-CF/terraform-azurerm-automation-account"
  automation_account_name    = "${local.resource_prefix}-aa"
  resource_group_name        = data.terraform_remote_state.setup.outputs.management_rg_name
  location                   = var.location
  log_analytics_workspace_id = data.terraform_remote_state.core.outputs.core_la_id

  global_tags = var.global_tags
  regional_tags = merge({
    Function    = "Automation"
    Plane       = "Management"
    Environment = "Production"
  }, var.regional_tags, local.global_local_tags)
}
