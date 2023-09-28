locals {
  VM_IDs = [
    data.terraform_remote_state.ussc_web.outputs.ussc_web1_id,
    data.terraform_remote_state.ussc_web.outputs.ussc_web2_id,
    data.terraform_remote_state.ussc_web.outputs.ussc_web3_id,
    data.terraform_remote_state.ussc_web.outputs.ussc_web4_id,
    data.terraform_remote_state.ussc_sql.outputs.ussc_sql1_id,
  ]
  vm_id_map = { for vm_id in local.VM_IDs : vm_id => vm_id }
}

resource "azurerm_backup_protected_vm" "backupVM" {
  for_each            = local.vm_id_map
  resource_group_name = data.terraform_remote_state.ussc-setup.outputs.management_rg_name
  recovery_vault_name = azurerm_recovery_services_vault.ars_vault.name
  backup_policy_id    = azurerm_backup_policy_vm.backupVM_policy_2am_utc.id
  source_vm_id        = each.value
}

resource "azurerm_backup_policy_vm" "backupVM_policy_2am_utc" {
  name                = "backupVM_policy_2am_utc"
  resource_group_name = data.terraform_remote_state.ussc-setup.outputs.management_rg_name
  recovery_vault_name = azurerm_recovery_services_vault.ars_vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "02:00"
  }

  retention_daily {
    count = 7
  }

  retention_weekly {
    count    = 3
    weekdays = ["Sunday", "Wednesday"]
  }
}
