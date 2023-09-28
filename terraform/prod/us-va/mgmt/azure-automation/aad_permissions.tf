resource "azurerm_role_assignment" "assign_sub_vmcontributor" {
  for_each             = toset(concat([var.subscription_id], values(var.app_subscription_ids)))
  scope                = "/subscriptions/${each.key}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_automation_account.va-aa.identity.0.principal_id

  depends_on = [
    azurerm_automation_account.va-aa
  ]
}