resource "azurerm_role_assignment" "assign_sub_vmcontributor" {
  for_each             = toset(concat([var.subscription_id], values(var.app_subscription_ids)))
  scope                = "/subscriptions/${each.key}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = module.va-aa.aa_principal_id

  depends_on = [
    module.va-aa
  ]
}