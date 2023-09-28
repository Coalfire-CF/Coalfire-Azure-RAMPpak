output "usgv_aa_id" {
  value = azurerm_automation_account.va-aa.id
}

output "usgv_aa_dsc_endpoint" {
  value = azurerm_automation_account.va-aa.dsc_server_endpoint
}

output "usgv_aa_name" {
  value = azurerm_automation_account.va-aa.name
}

output "usgv_aa_principal_id" {
  value = azurerm_automation_account.va-aa.identity.0.principal_id
}

output "usgv_aa_primary_registration" {
  value     = azurerm_automation_account.va-aa.dsc_primary_access_key
  sensitive = true
}
