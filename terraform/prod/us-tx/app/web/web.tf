resource "azurerm_availability_set" "web_availability_set" {
  name                         = "z${var.location_abbreviation}ap${var.app_abbreviation}webas1"
  location                     = var.location
  resource_group_name          = data.terraform_remote_state.ussc-setup.outputs.application_rg_name
  platform_update_domain_count = 2
  platform_fault_domain_count  = 2
  tags = {
    Function = "Web"
    Plane    = "Application"
  }
}

module "web1" {
  source = "github.com/Coalfire-CF/ACE-Azure-VM-Windows"

  vm_name                       = "z${var.location_abbreviation}ap${var.app_abbreviation}web1"
  vm_admin_username             = var.vm_admin_username
  location                      = var.location
  resource_group_name           = data.terraform_remote_state.ussc-setup.outputs.application_rg_name
  size                          = "Standard_D4s_v3"
  source_image_id               = data.terraform_remote_state.setup.outputs.windows_golden_id
  availability_set_id           = azurerm_availability_set.web_availability_set.id
  enable_public_ip              = false
  subnet_id                     = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_subnet_ids[1]
  private_ip_address_allocation = "Dynamic"
  dj_kv_id                      = data.terraform_remote_state.key_vaults.outputs.use2_dj_kv_id
  vm_diag_sa                    = data.terraform_remote_state.setup.outputs.vmdiag_endpoint
  regional_tags                 = var.regional_tags
  global_tags                   = var.global_tags
  storage_account_vmdiag_name   = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_name
  vm_tags = {
    OS         = "Windows_2019"
    Function   = "Web"
    Plane      = "Application"
    Stopinator = "False"
  }
}

resource "azurerm_role_assignment" "web1_ad_kv_assignment" {
  scope                = data.terraform_remote_state.key_vaults.outputs.use2_ad_kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.web1.vm_system_identity
}

data "azurerm_key_vault_secret" "domain_join" {
  name         = "svc-dj"
  key_vault_id = data.terraform_remote_state.key_vaults.outputs.use2_dj_kv_id
}

resource "azurerm_virtual_machine_extension" "web1-domjoin" {
  name                       = "domjoin"
  virtual_machine_id         = module.web1.vm_id
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
    "Name": "azurelaunchpad.com",
    "OUPath": "OU=Windows,OU=Production,OU=azurelaunchpad,OU=Servers,DC=azurelaunchpad,DC=com",
    "User": "azurelaunchpad.com\\svc-dj",
    "Restart": "true",
    "Options": "3"
  }
  SETTINGS
}

resource "azurerm_network_interface_security_group_association" "web1_nsg_assoc" {
  network_interface_id      = module.web1.network_interface_ids[0]
  network_security_group_id = module.web-nsg.network_security_group_id
}


module "web2" {
  source = "github.com/Coalfire-CF/ACE-Azure-VM-Windows"

  vm_name                       = "z${var.location_abbreviation}ap${var.app_abbreviation}web2"
  vm_admin_username             = var.vm_admin_username
  location                      = var.location
  resource_group_name           = data.terraform_remote_state.ussc-setup.outputs.application_rg_name
  size                          = "Standard_D4s_v3"
  source_image_id               = data.terraform_remote_state.setup.outputs.windows_golden_id
  availability_set_id           = azurerm_availability_set.web_availability_set.id
  enable_public_ip              = false
  subnet_id                     = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_subnet_ids[1]
  private_ip_address_allocation = "Dynamic"
  dj_kv_id                      = data.terraform_remote_state.key_vaults.outputs.use2_dj_kv_id
  vm_diag_sa                    = data.terraform_remote_state.setup.outputs.vmdiag_endpoint
  regional_tags                 = var.regional_tags
  global_tags                   = var.global_tags
  storage_account_vmdiag_name   = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_name
  vm_tags = {
    OS         = "Windows_2019"
    Function   = "Web"
    Plane      = "Application"
    Stopinator = "False"
  }
}

resource "azurerm_role_assignment" "web2_ad_kv_assignment" {
  scope                = data.terraform_remote_state.key_vaults.outputs.use2_ad_kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.web2.vm_system_identity
}

resource "azurerm_virtual_machine_extension" "web2-domjoin" {
  name                       = "domjoin"
  virtual_machine_id         = module.web2.vm_id
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
    "Name": "azurelaunchpad.com",
    "OUPath": "OU=Windows,OU=Production,OU=azurelaunchpad,OU=Servers,DC=azurelaunchpad,DC=com",
    "User": "azurelaunchpad.com\\svc-dj",
    "Restart": "true",
    "Options": "3"
  }
  SETTINGS
}

resource "azurerm_network_interface_security_group_association" "web2_nsg_assoc" {
  network_interface_id      = module.web2.network_interface_ids[0]
  network_security_group_id = module.web-nsg.network_security_group_id
}
module "web-nsg" {
  source = "../../../../modules/azurerm-network-security-group/"

  resource_group_name         = data.terraform_remote_state.ussc-setup.outputs.network_rg_name
  security_group_name         = "${var.location_abbreviation}-ap-${var.app_abbreviation}-web-nsg"
  storage_account_flowlogs_id = data.terraform_remote_state.ussc-setup.outputs.storage_account_flowlogs_id
  network_watcher_name        = data.terraform_remote_state.ussc-setup.outputs.network_watcher_name

  custom_rules = [
    {
      name                    = "RDP"
      priority                = "1000"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "tcp"
      destination_port_range  = "3389"
      source_address_prefixes = ["${var.ip_network_mgmt}.0.0/16", "${var.ip_network_app}.0.0/16"]
      description             = "RDP"
    },
    {
      name                    = "DNS"
      priority                = "1100"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "*"
      destination_port_range  = "53"
      source_address_prefixes = ["${var.ip_network_mgmt}.0.0/16", "${var.ip_network_app}.0.0/16"]
      description             = "DNS Service"
    },
    {
      name                    = "AnsibleWindows"
      priority                = "1200"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "tcp"
      destination_port_range  = "5985-5986"
      source_address_prefixes = ["${var.ip_network_mgmt}.3.0/24"]
      description             = "Ansible management port for windows VMs"
    },
    {
      name                    = "NessusWindows"
      priority                = "1300"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "tcp"
      destination_port_range  = "139,445"
      source_address_prefixes = ["${var.ip_network_mgmt}.4.0/24"]
      description             = "Nessus Scan port for windows VMs"
    },
    {
      name                    = "DSM"
      priority                = "1400"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "tcp"
      destination_port_range  = "4118"
      source_address_prefixes = ["${var.ip_network_mgmt}.4.0/24"]
      description             = "Trend DSM bidirectional port for windows VMs"
    },
    {
      name                    = "HTTPS"
      priority                = "1500"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "tcp"
      destination_port_range  = "443"
      source_address_prefixes = [data.terraform_remote_state.ussc_app_gateway.outputs.ussc_app_gateway_ip, "${var.ip_network_app}.2.0/24"]
      description             = "HTTPS"
    }
  ]
}

data "azurerm_monitor_diagnostic_categories" "diag_options" {
  resource_id = module.web-nsg.network_security_group_id
}

module "web-nsg-diag" {
  source                = "../../../../modules/coalfire-diagnostic/"
  diag_name             = "web-nsg-diag"
  resource_id           = module.web-nsg.network_security_group_id
  diag_eventhub_name    = data.terraform_remote_state.ussc-setup.outputs.diag_eventhub_name
  diag_eventhub_auth_id = data.terraform_remote_state.ussc-setup.outputs.diag_eventhub_auth_id
  diag_logs             = data.azurerm_monitor_diagnostic_categories.diag_options.logs
  diag_metrics          = data.azurerm_monitor_diagnostic_categories.diag_options.metrics
}

resource "azurerm_availability_set" "web_availability_set_2" {
  name                         = "z${var.location_abbreviation}ap${var.app_abbreviation}webas2"
  location                     = var.location
  resource_group_name          = data.terraform_remote_state.ussc-setup.outputs.application_rg_name
  platform_update_domain_count = 2
  platform_fault_domain_count  = 2
  tags = {
    Function = "Web"
    Plane    = "Application"
  }
}

module "web3" {
  source = "github.com/Coalfire-CF/ACE-Azure-VM-Windows"

  vm_name                       = "z${var.location_abbreviation}ap${var.app_abbreviation}web3"
  vm_admin_username             = var.vm_admin_username
  location                      = var.location
  resource_group_name           = data.terraform_remote_state.ussc-setup.outputs.application_rg_name
  size                          = "Standard_D4s_v3"
  source_image_id               = data.terraform_remote_state.setup.outputs.windows_golden_id
  availability_set_id           = azurerm_availability_set.web_availability_set_2.id
  enable_public_ip              = false
  subnet_id                     = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_subnet_ids[1]
  private_ip_address_allocation = "Dynamic"
  dj_kv_id                      = data.terraform_remote_state.key_vaults.outputs.use2_dj_kv_id
  vm_diag_sa                    = data.terraform_remote_state.setup.outputs.vmdiag_endpoint
  regional_tags                 = var.regional_tags
  global_tags                   = var.global_tags
  storage_account_vmdiag_name   = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_name
  vm_tags = {
    OS         = "Windows_2019"
    Function   = "Web"
    Plane      = "Application"
    Stopinator = "False"
  }
}

resource "azurerm_role_assignment" "web3_ad_kv_assignment" {
  scope                = data.terraform_remote_state.key_vaults.outputs.use2_ad_kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.web3.vm_system_identity
}

resource "azurerm_virtual_machine_extension" "web3-domjoin" {
  name                       = "domjoin"
  virtual_machine_id         = module.web3.vm_id
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
    "Name": "azurelaunchpad.com",
    "OUPath": "OU=Windows,OU=Production,OU=azurelaunchpad,OU=Servers,DC=azurelaunchpad,DC=com",
    "User": "azurelaunchpad.com\\svc-dj",
    "Restart": "true",
    "Options": "3"
  }
  SETTINGS
}

resource "azurerm_network_interface_security_group_association" "web3_nsg_assoc" {
  network_interface_id      = module.web3.network_interface_ids[0]
  network_security_group_id = module.web-nsg.network_security_group_id
}


module "web4" {
  source = "github.com/Coalfire-CF/ACE-Azure-VM-Windows"

  vm_name                       = "z${var.location_abbreviation}ap${var.app_abbreviation}web4"
  vm_admin_username             = var.vm_admin_username
  location                      = var.location
  resource_group_name           = data.terraform_remote_state.ussc-setup.outputs.application_rg_name
  size                          = "Standard_D4s_v3"
  source_image_id               = data.terraform_remote_state.setup.outputs.windows_golden_id
  availability_set_id           = azurerm_availability_set.web_availability_set_2.id
  enable_public_ip              = false
  subnet_id                     = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_subnet_ids[1]
  private_ip_address_allocation = "Dynamic"
  dj_kv_id                      = data.terraform_remote_state.key_vaults.outputs.use2_dj_kv_id
  vm_diag_sa                    = data.terraform_remote_state.setup.outputs.vmdiag_endpoint
  regional_tags                 = var.regional_tags
  global_tags                   = var.global_tags
  storage_account_vmdiag_name   = data.terraform_remote_state.setup.outputs.storage_account_vmdiag_name
  vm_tags = {
    OS         = "Windows_2019"
    Function   = "Web"
    Plane      = "Application"
    Stopinator = "False"
  }
}

resource "azurerm_role_assignment" "web4_ad_kv_assignment" {
  scope                = data.terraform_remote_state.key_vaults.outputs.use2_ad_kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.web4.vm_system_identity
}

resource "azurerm_virtual_machine_extension" "web4-domjoin" {
  name                       = "domjoin"
  virtual_machine_id         = module.web4.vm_id
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
    "Name": "azurelaunchpad.com",
    "OUPath": "OU=Windows,OU=Production,OU=azurelaunchpad,OU=Servers,DC=azurelaunchpad,DC=com",
    "User": "azurelaunchpad.com\\svc-dj",
    "Restart": "true",
    "Options": "3"
  }
  SETTINGS
}

resource "azurerm_network_interface_security_group_association" "web4_nsg_assoc" {
  network_interface_id      = module.web4.network_interface_ids[0]
  network_security_group_id = module.web-nsg.network_security_group_id
}
