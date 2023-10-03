module "sentinel" {
  source = "github.com/Coalfire-CF/terraform-azurerm-sentinel"

  name                         = "${local.resource_prefix}-sentinel"
  resource_group_name          = data.terraform_remote_state.setup.outputs.management_rg_name
  location                     = var.location
  log_analytics_workspace_id   = data.terraform_remote_state.core.outputs.core_la_workspace_id
  log_analytics_workspace_name = data.terraform_remote_state.core.outputs.core_la_workspace_name

  global_tags   = var.global_tags
  regional_tags = merge({
    Function    = "SEIM"
    Plane       = "Management"
    Environment = "Production"
  }, var.regional_tags, local.global_local_tags)
}




# resource "azurerm_log_analytics_solution" "tm-sentinel" {
#   solution_name         = "SecurityInsights"
#   location              = var.location
#   resource_group_name   = data.terraform_remote_state.core.outputs.core_rg_name
#   workspace_resource_id = data.terraform_remote_state.core.outputs.core_la_workspace_id
#   workspace_name        = data.terraform_remote_state.core.outputs.core_la_workspace_name

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/SecurityInsights"
#   }
# }

# # It appears enabling this manually may not be required. Initial deployment showed this getting enabled based on the logs
# # already existing in the workspace
# # resource "azurerm_sentinel_data_connector_azure_active_directory" "sentinel-aad" {
# #   name                       = "AAD-Connector"
# #   log_analytics_workspace_id = data.terraform_remote_state.core.outputs.core_la_workspace_id
# # }

# resource "azurerm_sentinel_data_connector_threat_intelligence" "sentinel-taxii" {
#   name                       = "TAXII"
#   log_analytics_workspace_id = data.terraform_remote_state.core.outputs.core_la_workspace_id
# }
