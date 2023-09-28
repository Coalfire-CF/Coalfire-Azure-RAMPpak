resource "azurerm_user_assigned_identity" "policies" {
  name                = "${local.resource_prefix}-policies-mi"
  resource_group_name = data.terraform_remote_state.core.outputs.core_rg_name
  location            = var.location

  tags = merge(var.regional_tags, var.global_tags, local.global_local_tags, {
    Plane = "Management"
  })
}

#Assign permissions to apply remediation's
resource "azurerm_role_assignment" "umi_con_permissions" {
  for_each             = local.subscription_ids
  scope                = "/subscriptions/${each.value}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.policies.principal_id
}

resource "azurerm_role_assignment" "umi_backup_permissions" {
  for_each             = local.subscription_ids
  scope                = "/subscriptions/${each.value}"
  role_definition_name = "Backup Contributor"
  principal_id         = azurerm_user_assigned_identity.policies.principal_id
}

resource "azurerm_role_assignment" "umi_vm_permissions" {
  for_each             = local.subscription_ids
  scope                = "/subscriptions/${each.value}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.policies.principal_id
}

#Assign FedRamp Initiative (Set Policy)
data "azurerm_policy_set_definition" "fedramp" {
  display_name = "FedRAMP Moderate"
}

resource "azurerm_subscription_policy_assignment" "fedramp" {
  for_each             = local.subscription_ids
  name                 = "FedRAMP Moderate"
  policy_definition_id = data.azurerm_policy_set_definition.fedramp.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}

# Assign CIS 1.3 initiative
data "azurerm_policy_set_definition" "cis" {
  display_name = "CIS Microsoft Azure Foundations Benchmark v1.3.0"
}

resource "azurerm_subscription_policy_assignment" "cis" {
  for_each             = local.subscription_ids
  name                 = "CIS Microsoft Azure Foundations Benchmark v1.3.0"
  policy_definition_id = data.azurerm_policy_set_definition.cis.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}
