resource "azurerm_recovery_services_vault" "ars_vault" {
  name                = "${local.resource_prefix}-backup-rsv"
  location            = var.location
  resource_group_name = data.terraform_remote_state.setup.outputs.management_rg_name
  sku                 = "Standard"
}

resource "azurerm_backup_container_storage_account" "container" {
  resource_group_name = data.terraform_remote_state.setup.outputs.management_rg_name
  recovery_vault_name = azurerm_recovery_services_vault.ars_vault.name
  storage_account_id  = data.terraform_remote_state.setup.outputs.storage_account_ars_id
}

resource "azurerm_backup_policy_vm" "default_policy" {
  name                = "backupvm_default_policy"
  resource_group_name = data.terraform_remote_state.setup.outputs.management_rg_name
  recovery_vault_name = azurerm_recovery_services_vault.ars_vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "02:00"
  }

  retention_daily {
    count = 14
  }

  retention_weekly {
    count    = 4
    weekdays = ["Sunday", "Wednesday"]
  }

  retention_monthly {
    count    = 3
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }
}

module "diag" {
  source                = "github.com/Coalfire-CF/terraform-azurerm-diagnostics"
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
  resource_id           = azurerm_recovery_services_vault.ars_vault.id
  resource_type         = "rsv"
}