resource "azurerm_virtual_network_peering" "mgmt-app-peering" {
  name                      = "mgmt-to-app-peering"
  resource_group_name       = data.terraform_remote_state.setup.outputs.network_rg_name
  virtual_network_name      = data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.usgv_app_vnet.outputs.usgv_app_vnet_id
}

resource "azurerm_virtual_network_peering" "app-mgmt-peering" {
  name                      = "app-to-mgmt-peering"
  resource_group_name       = data.terraform_remote_state.setup.outputs.network_rg_name
  virtual_network_name      = data.terraform_remote_state.usgv_app_vnet.outputs.usgv_app_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_vnet_id
}
