## Windows
module "bastion1" {
  source = "github.com/Coalfire-CF/terraform-azurerm-vm-windows?ref=OC"

  vm_name                       = length("${local.vm_name_prefix_mgmt}ba1") <= 15 ? "${local.vm_name_prefix_mgmt}ba1" : "${data.terraform_remote_state.mgmt_naming.outputs.virtual_machine}-ba1"
  vm_admin_username             = var.vm_admin_username
  location                      = var.location
  resource_group_name           = data.terraform_remote_state.core.outputs.core_rg_name
  size                          = "Standard_DS2_v2"
  enable_public_ip              = false
  subnet_id                     = data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_security_edge_vnet_subnet_ids["${data.terraform_remote_state.mgmt_naming.outputs.subnet}-sebe"]
  private_ip_address_allocation = "Static"
  private_ip                    = cidrhost(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_security_edge_networks["${data.terraform_remote_state.mgmt_naming.outputs.subnet}-sebe"], 10)
  vm_diag_sa                    = data.terraform_remote_state.setup.outputs.vmdiag_endpoint
  regional_tags                 = var.regional_tags
  global_tags                   = var.global_tags
  storage_account_vmdiag_name   = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_name

  source_image_reference = {
    publisher = "center-for-internet-security-inc"
    offer     = "cis-win-2019-stig"
    sku       = "cis-win-2019-stig"
    version   = "latest"
  }

  vm_tags = {
    OS       = "Windows_STIG_2019"
    Function = "Bastion"
    Plane    = "Management"
  }
}

