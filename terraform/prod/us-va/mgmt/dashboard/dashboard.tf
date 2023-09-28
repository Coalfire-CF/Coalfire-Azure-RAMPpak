resource "azurerm_portal_dashboard" "inventory_dashboard" {
  name                 = "${local.resource_prefix}-inventory-dashboard"
  resource_group_name  = data.terraform_remote_state.setup.outputs.management_rg_name
  location             = var.location
  tags                 = merge(var.regional_tags, var.global_tags, local.global_local_tags)
  dashboard_properties = file("./templates/inventory_dashboard.json")
}