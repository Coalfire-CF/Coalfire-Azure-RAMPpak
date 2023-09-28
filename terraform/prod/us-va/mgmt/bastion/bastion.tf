## Windows
module "bastion1" {
  source = "github.com/Coalfire-CF/ACE-Azure-VM-Windows"

  vm_name                       = length("${local.vm_name_prefix_mgmt}ba1") <= 15 ? "${local.vm_name_prefix_mgmt}ba1" : "${data.terraform_remote_state.mgmt_naming.outputs.virtual_machine}-ba1"
  vm_admin_username             = var.vm_admin_username
  location                      = var.location
  resource_group_name           = data.terraform_remote_state.core.outputs.core_rg_name
  size                          = "Standard_DS2_v2"
  source_image_id               = data.terraform_remote_state.setup.outputs.windows_golden_id
  enable_public_ip              = false
  subnet_id                     = data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_security_edge_vnet_subnet_ids["${data.terraform_remote_state.mgmt_naming.outputs.subnet}-sebe"]
  private_ip_address_allocation = "Static"
  private_ip                    = cidrhost(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_security_edge_networks["${data.terraform_remote_state.mgmt_naming.outputs.subnet}-sebe"], 10)
  dj_kv_id                      = data.terraform_remote_state.usgv_key_vaults.outputs.usgv_dj_kv_id
  vm_diag_sa                    = data.terraform_remote_state.setup.outputs.vmdiag_endpoint
  regional_tags                 = var.regional_tags
  global_tags                   = var.global_tags
  storage_account_vmdiag_name   = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_name
  vm_tags = {
    OS           = "Windows_2019"
    Function     = "Bastion"
    Plane        = "Management"
    Stopinator   = "True"
    AutoStartup  = "07:30"
    AutoShutdown = "17:00"
  }
}

resource "azurerm_role_assignment" "bastion1_ad_kv_assignment" {
  scope                = data.terraform_remote_state.usgv_key_vaults.outputs.usgv_ad_kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.bastion1.vm_system_identity
}

data "azurerm_key_vault_secret" "domain_join" {
  name         = "svc-dj"
  key_vault_id = data.terraform_remote_state.usgv_key_vaults.outputs.usgv_dj_kv_id
}

resource "azurerm_virtual_machine_extension" "ba1-domjoin" {
  name                       = "domjoin"
  virtual_machine_id         = module.bastion1.vm_id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = "true"

  protected_settings = <<PROTECTED_SETTINGS
  {
    "Password": "${data.azurerm_key_vault_secret.domain_join.value}"
  }
PROTECTED_SETTINGS

  settings = <<SETTINGS
  {
    "Name": "internal-mark43-staging.us",
    "OUPath": "OU=Windows,OU=VA,OU=Stage,OU=Servers,OU=Mark43Government,DC=internal-mark43-staging,DC=us",
    "User": "mark43-gov-stg\\svc-dj",
    "Restart": "true",
    "Options": "3"
  }
  SETTINGS
}


## Windows 2
module "bastion2" {
  source = "github.com/Coalfire-CF/ACE-Azure-VM-Windows"

  vm_name                       = length("${local.vm_name_prefix_mgmt}ba2") <= 15 ? "${local.vm_name_prefix_mgmt}ba2" : "${data.terraform_remote_state.mgmt_naming.outputs.virtual_machine}-ba2"
  vm_admin_username             = var.vm_admin_username
  location                      = var.location
  resource_group_name           = data.terraform_remote_state.core.outputs.core_rg_name
  size                          = "Standard_DS2_v2"
  source_image_id               = data.terraform_remote_state.setup.outputs.windows_golden_id
  enable_public_ip              = false
  subnet_id                     = data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_security_edge_vnet_subnet_ids["${data.terraform_remote_state.mgmt_naming.outputs.subnet}-sebe"]
  private_ip_address_allocation = "Static"
  private_ip                    = cidrhost(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_security_edge_networks["${data.terraform_remote_state.mgmt_naming.outputs.subnet}-sebe"], 20)
  dj_kv_id                      = data.terraform_remote_state.usgv_key_vaults.outputs.usgv_dj_kv_id
  vm_diag_sa                    = data.terraform_remote_state.setup.outputs.vmdiag_endpoint
  regional_tags                 = var.regional_tags
  global_tags                   = var.global_tags
  storage_account_vmdiag_name   = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_name
  vm_tags = {
    OS           = "Windows_2019"
    Function     = "Bastion"
    Plane        = "Management"
    Stopinator   = "True"
    AutoStartup  = "07:30"
    AutoShutdown = "17:00"
  }
}

resource "azurerm_role_assignment" "bastion2_ad_kv_assignment" {
  scope                = data.terraform_remote_state.usgv_key_vaults.outputs.usgv_ad_kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.bastion2.vm_system_identity
}

resource "azurerm_virtual_machine_extension" "ba2-domjoin" {
  name                       = "domjoin"
  virtual_machine_id         = module.bastion2.vm_id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = "true"

  protected_settings = <<PROTECTED_SETTINGS
  {
    "Password": "${data.azurerm_key_vault_secret.domain_join.value}"
  }
PROTECTED_SETTINGS

  settings = <<SETTINGS
  {
    "Name": "internal-mark43-staging.us",
    "OUPath": "OU=Windows,OU=VA,OU=Stage,OU=Servers,OU=Mark43Government,DC=internal-mark43-staging,DC=us",
    "User": "mark43-gov-stg\\svc-dj",
    "Restart": "true",
    "Options": "3"
  }
  SETTINGS
}

resource "azurerm_network_interface_security_group_association" "ba1_nsg_assoc" {
  network_interface_id      = module.bastion1.network_interface_ids[0]
  network_security_group_id = module.win_bastion_nsg.network_security_group_id
}

resource "azurerm_network_interface_security_group_association" "ba2_nsg_assoc" {
  network_interface_id      = module.bastion2.network_interface_ids[0]
  network_security_group_id = module.win_bastion_nsg.network_security_group_id
}

# Linux
module "bastion3" {
  source = "github.com/Coalfire-CF/ACE-Azure-VM-Linux"

  vm_name                         = length("${local.vm_name_prefix_mgmt}ba3") <= 15 ? "${local.vm_name_prefix_mgmt}ba3" : "${data.terraform_remote_state.mgmt_naming.outputs.virtual_machine}-ba3"
  vm_admin_username               = var.vm_admin_username
  location                        = var.location
  resource_group_name             = data.terraform_remote_state.core.outputs.core_rg_name
  size                            = "Standard_DS2_v2"
  source_image_id                 = data.terraform_remote_state.setup.outputs.rhel8_id
  enable_public_ip                = false
  subnet_id                       = data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_security_edge_vnet_subnet_ids["${data.terraform_remote_state.mgmt_naming.outputs.subnet}-sebe"]
  availability_zone               = var.availability_zone_1
  private_ip_address_allocation   = "Static"
  private_ip                      = cidrhost(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_security_edge_networks["${data.terraform_remote_state.mgmt_naming.outputs.subnet}-sebe"], 30)
  vm_diag_sa                      = data.terraform_remote_state.setup.outputs.vmdiag_endpoint
  regional_tags                   = var.regional_tags
  global_tags                     = var.global_tags
  storage_account_vmdiag_name     = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_name
  diagnostics_storage_account_key = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_sas
  ssh_public_key                  = data.terraform_remote_state.core.outputs.core_xadm_ssh_public_key

  la_name                 = data.terraform_remote_state.core.outputs.core_la_workspace_name
  la_resource_group_name  = data.terraform_remote_state.core.outputs.core_rg_name
  linux_monitor_agent_url = data.terraform_remote_state.setup.outputs.usgv_linux_monitor_agent_url
  sa_install_id           = data.terraform_remote_state.setup.outputs.storage_account_install_id
  la_workspace_id         = data.terraform_remote_state.core.outputs.core_la_workspace_id

  domain_join = {
    domain_name           = var.domain_name
    disname               = var.dom_disname
    linux_admins_ad_group = var.linux_admins_ad_group
    user_name             = var.domain_join_user_name
    azure_cloud           = var.azure_cloud
    linux_domainjoin_url  = data.terraform_remote_state.setup.outputs.usgv_linux_domainjoin_url
    dj_kv_id              = data.terraform_remote_state.usgv_key_vaults.outputs.usgv_dj_kv_id
  }

  vm_tags = {
    OS           = "RHEL8"
    Function     = "Bastion"
    Plane        = "Management"
    Stopinator   = "True"
    AutoStartup  = "07:30"
    AutoShutdown = "17:00"
  }

}

resource "azurerm_network_interface_security_group_association" "ba3_ad_nsg_assoc" {
  network_interface_id      = module.bastion3.network_interface_ids[0]
  network_security_group_id = module.lin_bastion_nsg.network_security_group_id
}

resource "random_password" "ba3_adminPass" {
  length           = 15
  special          = true
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "!@#%"
}

resource "azurerm_key_vault_secret" "admin-pass" {
  name         = "admin"
  value        = random_password.ba3_adminPass.result
  key_vault_id = data.terraform_remote_state.usgv_key_vaults.outputs.usgv_dj_kv_id
  tags = {
  }
}

resource "time_sleep" "wait_for_bastion3_to_finish" {
  depends_on      = [module.bastion3.ext_id, module.bastion3.vm_id]
  create_duration = "120s"
}


module "bastion4" {
  source     = "github.com/Coalfire-CF/ACE-Azure-VM-Linux"
  depends_on = [time_sleep.wait_for_bastion3_to_finish]

  vm_name                         = length("${local.vm_name_prefix_mgmt}ba4") <= 15 ? "${local.vm_name_prefix_mgmt}ba4" : "${data.terraform_remote_state.mgmt_naming.outputs.virtual_machine}-ba4"
  vm_admin_username               = var.vm_admin_username
  location                        = var.location
  resource_group_name             = data.terraform_remote_state.core.outputs.core_rg_name
  size                            = "Standard_DS2_v2"
  source_image_id                 = data.terraform_remote_state.setup.outputs.rhel8_id
  enable_public_ip                = false
  subnet_id                       = data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_security_edge_vnet_subnet_ids["${data.terraform_remote_state.mgmt_naming.outputs.subnet}-sebe"]
  availability_zone               = var.availability_zone_1
  private_ip_address_allocation   = "Static"
  private_ip                      = cidrhost(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_security_edge_networks["${data.terraform_remote_state.mgmt_naming.outputs.subnet}-sebe"], 40)
  vm_diag_sa                      = data.terraform_remote_state.setup.outputs.vmdiag_endpoint
  regional_tags                   = var.regional_tags
  global_tags                     = var.global_tags
  storage_account_vmdiag_name     = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_name
  diagnostics_storage_account_key = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_sas
  ssh_public_key                  = data.terraform_remote_state.core.outputs.core_xadm_ssh_public_key

  la_name                 = data.terraform_remote_state.core.outputs.core_la_workspace_name
  la_resource_group_name  = data.terraform_remote_state.core.outputs.core_rg_name
  linux_monitor_agent_url = data.terraform_remote_state.setup.outputs.usgv_linux_monitor_agent_url
  sa_install_id           = data.terraform_remote_state.setup.outputs.storage_account_install_id
  la_workspace_id         = data.terraform_remote_state.core.outputs.core_la_workspace_id

  domain_join = {
    domain_name           = var.domain_name
    disname               = var.dom_disname
    linux_admins_ad_group = var.linux_admins_ad_group
    user_name             = var.domain_join_user_name
    azure_cloud           = var.azure_cloud
    linux_domainjoin_url  = data.terraform_remote_state.setup.outputs.usgv_linux_domainjoin_url
    dj_kv_id              = data.terraform_remote_state.usgv_key_vaults.outputs.usgv_dj_kv_id
  }

  vm_tags = {
    OS           = "RHEL8"
    Function     = "Bastion"
    Plane        = "Management"
    Stopinator   = "True"
    AutoStartup  = "07:30"
    AutoShutdown = "17:00"
  }

}

resource "azurerm_network_interface_security_group_association" "ba4_ad_nsg_assoc" {
  network_interface_id      = module.bastion4.network_interface_ids[0]
  network_security_group_id = module.lin_bastion_nsg.network_security_group_id
}

resource "random_password" "ba4_adminPass" {
  length           = 15
  special          = true
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "!@#%"
}

resource "azurerm_key_vault_secret" "ba4_adminPass" {
  name         = "admin"
  value        = random_password.ba4_adminPass.result
  key_vault_id = data.terraform_remote_state.usgv_key_vaults.outputs.usgv_dj_kv_id
  tags = {
  }
}


module "diag_ba1_nic" {
  source                = "../../../../modules/coalfire-diagnostic/"
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
  resource_id           = module.bastion1.network_interface_ids[0]
  resource_type         = "nic"
}

module "diag_ba2_nic" {
  source                = "../../../../modules/coalfire-diagnostic/"
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
  resource_id           = module.bastion2.network_interface_ids[0]
  resource_type         = "nic"
}


module "diag_ba3_nic" {
  source                = "../../../../modules/coalfire-diagnostic/"
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
  resource_id           = module.bastion3.network_interface_ids[0]
  resource_type         = "nic"
}

module "diag_ba4_nic" {
  source                = "../../../../modules/coalfire-diagnostic/"
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
  resource_id           = module.bastion4.network_interface_ids[0]
  resource_type         = "nic"
}