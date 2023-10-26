## Windows
module "bastion1" {
  source = "github.com/Coalfire-CF/terraform-azurerm-vm-windows"

  vm_name                       = "${local.vm_name_prefix}ba1"
  vm_admin_username             = var.vm_admin_username
  location                      = var.location
  resource_group_name           = data.terraform_remote_state.core.outputs.core_rg_name
  size                          = "Standard_DS2_v2"
  enable_public_ip              = true
  subnet_id                     = data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_vnet_subnet_ids["${local.resource_prefix}-bastion-sn-1"]
  private_ip_address_allocation = "Dynamic"
  vm_diag_sa                    = data.terraform_remote_state.setup.outputs.vmdiag_endpoint
  storage_account_vmdiag_name   = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_name
  kv_id                         = data.terraform_remote_state.core.outputs.core_kv_id
  trusted_launch                = false # For now, we are not using trusted launch. Fails with the CIS marketplace image.

  regional_tags = var.regional_tags
  global_tags   = var.global_tags

  source_image_reference = {
    publisher = "center-for-internet-security-inc"
    offer     = "cis-win-2019-stig"
    sku       = "cis-win-2019-stig"
    version   = "latest"
  }

  plan = {
    publisher = "center-for-internet-security-inc"
    name      = "cis-win-2019-stig"
    product   = "cis-win-2019-stig"
  }

  vm_tags = {
    OS       = "Windows_STIG_2019"
    Function = "Bastion"
    Plane    = "Management"
  }
}

