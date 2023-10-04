output "usgv_mgmt_recovery_vault_id" {
  value = azurerm_recovery_services_vault.ars_vault.id
}

output "usgv_mgmt_backupvm_default_policy_name" {
  value = azurerm_backup_policy_vm.default_policy.name
}

output "usgv_mgmt_backupvm_tag_key" {
  value = "BackupPolicy"
}

output "usgv_mgmt_backupvm_tag_value" {
  value = azurerm_backup_policy_vm.default_policy.name
}

output "usgv_mgmt_backupvm_default_policy_id" {
  value = azurerm_backup_policy_vm.default_policy.id
}