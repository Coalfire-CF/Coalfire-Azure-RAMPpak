data "azurerm_policy_definition" "aks_host_path" {
  display_name = "Kubernetes cluster pod hostPath volumes should only use allowed host paths"
}
data "azurerm_policy_definition" "aks_noprivileged_containers" {
  display_name = "Kubernetes cluster should not allow privileged containers"
}
data "azurerm_policy_definition" "aks_host_network" {
  display_name = "Kubernetes cluster pods should only use approved host network and port range"
}
data "azurerm_policy_definition" "aks_host_noshare_process" {
  display_name = "Kubernetes cluster containers should not share host process ID or host IPC namespace"
}
data "azurerm_policy_definition" "aks_no_sys_admin" {
  display_name = "Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities"
}
data "azurerm_policy_definition" "aks_allowed_capabilities" {
  display_name = "Kubernetes cluster containers should only use allowed capabilities"
}
data "azurerm_policy_definition" "aks_nolocal_authentication" {
  display_name = "Azure Kubernetes Service Clusters should have local authentication methods disabled"
}
data "azurerm_policy_definition" "aks_https_only" {
  display_name = "Kubernetes clusters should be accessible only over HTTPS"
}
data "azurerm_policy_definition" "aks_nocontainer_privilege_escalation" {
  display_name = "Kubernetes clusters should not allow container privilege escalation"
}

resource "azurerm_subscription_policy_assignment" "aks_host_path" {
  for_each             = local.subscription_ids
  name                 = "aks_host_path-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.aks_host_path.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}

resource "azurerm_subscription_policy_assignment" "aks_noprivileged_containers" {
  for_each             = local.subscription_ids
  name                 = "aks_noprivileged_containers-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.aks_noprivileged_containers.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}

resource "azurerm_subscription_policy_assignment" "aks_host_network" {
  for_each             = local.subscription_ids
  name                 = "aks_host_network-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.aks_host_network.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}

resource "azurerm_subscription_policy_assignment" "aks_host_noshare_process" {
  for_each             = local.subscription_ids
  name                 = "aks_host_noshare_process-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.aks_host_noshare_process.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}

resource "azurerm_subscription_policy_assignment" "aks_no_sys_admin" {
  for_each             = local.subscription_ids
  name                 = "aks_no_sys_admin-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.aks_no_sys_admin.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}

resource "azurerm_subscription_policy_assignment" "aks_allowed_capabilities" {
  for_each             = local.subscription_ids
  name                 = "aks_allowed_capabilities-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.aks_allowed_capabilities.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location
  parameters           = <<PARAMETERS
    {
      "allowedCapabilities": {
        "value": [
          "CHOWN",
          "DAC_OVERRIDE",
          "FSETID",
          "FOWNER",
          "MKNOD",
          "NET_RAW",
          "SETGID",
          "SETUID",
          "SETFCAP",
          "SETPCAP",
          "NET_BIND_SERVICE",
          "SYS_CHROOT",
          "KILL",
          "AUDIT_WRITE"
        ]
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

resource "azurerm_subscription_policy_assignment" "aks_nolocal_authentication" {
  for_each             = local.subscription_ids
  name                 = "aks_nolocal_authentication-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.aks_nolocal_authentication.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}

resource "azurerm_subscription_policy_assignment" "aks_https_only" {
  for_each             = local.subscription_ids
  name                 = "aks_https_only-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.aks_https_only.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}

resource "azurerm_subscription_policy_assignment" "aks_nocontainer_privilege_escalation" {
  for_each             = local.subscription_ids
  name                 = "aks_nocontainer_privilege_escalation-policy-sub-assignment"
  policy_definition_id = data.azurerm_policy_definition.aks_nocontainer_privilege_escalation.id
  subscription_id      = "/subscriptions/${each.value}"
  location             = var.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.policies.id
    ]
  }
}