# Get Policy IDs
# data "azurerm_policy_definition" "webapp_auth_enabled" {
#   display_name = "Authentication should be enabled on your web app"
# }
data "azurerm_policy_definition" "locations_rg" {
  display_name = "Allowed locations for resource groups"
}
data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}
data "azurerm_policy_definition" "flowlogs_enabled" {
  display_name = "Flow logs should be configured for every network security group"
}
# data "azurerm_policy_definition" "api_app_auth_enabled" {
#   display_name = "Authentication should be enabled on your API app"
# }
data "azurerm_policy_definition" "storage_defender_enabled" {
  display_name = "Azure Defender for Storage should be enabled"
}
# data "azurerm_policy_definition" "functionapp_auth_enabled" {
#   display_name = "Authentication should be enabled on your Function app"
# }
data "azurerm_policy_definition" "psql_disconnections_logged" {
  display_name = "Disconnections should be logged for PostgreSQL database servers."
}
data "azurerm_policy_definition" "psql_log_connections_enabled" {
  display_name = "Log connections should be enabled for PostgreSQL database servers"
}
data "azurerm_policy_definition" "storage_allow_ms_services" {
  display_name = "Storage accounts should allow access from trusted Microsoft services"
}

#Apply policy to subscription (Bult-In)
# resource "azurerm_subscription_policy_assignment" "webapp_auth_enabled" {
#   for_each             = local.subscription_ids
#   name                 = "webapp_auth_enabled-policy-sub-assignment"
#   policy_definition_id = data.azurerm_policy_definition.webapp_auth_enabled.id
#   subscription_id      = "/subscriptions/${each.value}"
#   location             = var.location

#   identity {
#     type = "UserAssigned"
#     identity_ids = [
#       azurerm_user_assigned_identity.policies.id
#     ]
#   }
# }
resource "azurerm_subscription_policy_assignment" "locations_rg" {
  for_each             = local.subscription_ids
  name                 = "locations_rg-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.locations_rg.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location
  parameters           = <<PARAMETERS
    {
      "listOfAllowedLocations": {
        "value": ["${var.location}","${var.location_dr}"]
      }
    }
PARAMETERS

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}
resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  for_each             = local.subscription_ids
  name                 = "allowed_locations-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location
  parameters           = <<PARAMETERS
    {
      "listOfAllowedLocations": {
        "value": ["${var.location}","${var.location_dr}"]
      }
    }
PARAMETERS

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}
resource "azurerm_subscription_policy_assignment" "flowlogs_enabled" {
  for_each             = local.subscription_ids
  name                 = "flowlogs_enabled-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.flowlogs_enabled.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}
# resource "azurerm_subscription_policy_assignment" "api_app_auth_enabled" {
#   for_each             = local.subscription_ids
#   name                 = "api_app_auth_enabled-policy-sub-assignment"
#   policy_definition_id = data.azurerm_policy_definition.api_app_auth_enabled.id
#   subscription_id      = "/subscriptions/${each.value}"
#   location             = var.location

#   identity {
#     type = "UserAssigned"
#     identity_ids = [
#       azurerm_user_assigned_identity.policies.id
#     ]
#   }
# }
resource "azurerm_subscription_policy_assignment" "storage_defender_enabled" {
  for_each             = local.subscription_ids
  name                 = "storage_defender_enabled-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.storage_defender_enabled.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}
# resource "azurerm_subscription_policy_assignment" "functionapp_auth_enabled" {
#   for_each             = local.subscription_ids
#   name                 = "functionapp_auth_enabled-policy-sub-assignment"
#   policy_definition_id = data.azurerm_policy_definition.functionapp_auth_enabled.id
#   subscription_id      = "/subscriptions/${each.value}"
#   location             = var.location

#   identity {
#     type = "UserAssigned"
#     identity_ids = [
#       azurerm_user_assigned_identity.policies.id
#     ]
#   }
# }
resource "azurerm_subscription_policy_assignment" "psql_disconnections_logged" {
  for_each             = local.subscription_ids
  name                 = "psql_disconnections_logged-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.psql_disconnections_logged.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}
resource "azurerm_subscription_policy_assignment" "psql_log_connections_enabled" {
  for_each             = local.subscription_ids
  name                 = "psql_log_connections_enabled-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.psql_log_connections_enabled.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}
resource "azurerm_subscription_policy_assignment" "storage_allow_ms_services" {
  for_each             = local.subscription_ids
  name                 = "storage_allow_ms_services-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.storage_allow_ms_services.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}