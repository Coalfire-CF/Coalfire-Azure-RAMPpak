#ussc mgmt to app
resource "azurerm_virtual_network_peering" "ussc_mgmt-to-ussc_app-peering" {
  name                      = "ussc_mgmt-to-ussc_app-peering"
  resource_group_name       = data.terraform_remote_state.ussc-setup.outputs.network_rg_name
  virtual_network_name      = data.terraform_remote_state.ussc_mgmt_vnet.outputs.ussc_mgmt_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_id
}

#ussc app to mgmt
resource "azurerm_virtual_network_peering" "ussc_app-to-ussc_mgmt-peeringt" {
  name                      = "ussc_app-to-ussc_mgmt-peering"
  resource_group_name       = data.terraform_remote_state.ussc-setup.outputs.network_rg_name
  virtual_network_name      = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.ussc_mgmt_vnet.outputs.ussc_mgmt_vnet_id
}

##########
#app to app
resource "azurerm_virtual_network_peering" "use2_app-to-ussc_app-peering" {
  name                      = "use2_app-to-ussc_app-peering"
  resource_group_name       = data.terraform_remote_state.setup.outputs.network_rg_name
  virtual_network_name      = data.terraform_remote_state.use2_app_vnet.outputs.use2_app_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_id
}

resource "azurerm_virtual_network_peering" "ussc_app-to-use2_app-peering" {
  name                      = "ussc_app-to-use2_app-peering"
  resource_group_name       = data.terraform_remote_state.ussc-setup.outputs.network_rg_name
  virtual_network_name      = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.use2_app_vnet.outputs.use2_app_vnet_id
}


######
# use2 mgmt to ussc app
resource "azurerm_virtual_network_peering" "use2_mgmt-to-ussc_app-peering" {
  name                      = "use2_mgmt-to-ussc_app-peering"
  resource_group_name       = data.terraform_remote_state.setup.outputs.network_rg_name
  virtual_network_name      = data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_id
}

######
# ussc app to use2 mgmt
resource "azurerm_virtual_network_peering" "ussc_app-to-use2_mgmt-peering" {
  name                      = "ussc_app-to-use2_mgmt-peering"
  resource_group_name       = data.terraform_remote_state.ussc-setup.outputs.network_rg_name
  virtual_network_name      = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name
  remote_virtual_network_id = data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_id
}
