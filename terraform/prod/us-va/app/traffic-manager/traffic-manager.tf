resource "azurerm_traffic_manager_profile" "traffic_manager" {
  name                   = "${local.resource_prefix}-app-tmp"
  resource_group_name    = data.terraform_remote_state.setup.outputs.application_rg_name
  traffic_routing_method = "Priority"

  dns_config {
    relative_name = var.netbios_name
    ttl           = 30
  }

  monitor_config {
    protocol                     = "https"
    port                         = 443
    path                         = "/azurelaunchpad"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 5
  }

  tags = merge({
    Function = "Traffic"
    Plane    = "Application"
  }, var.global_tags, var.regional_tags)
}

resource "azurerm_traffic_manager_endpoint" "va_endpoint" {
  name                = "${local.resource_prefix}-app-tm-endpoint"
  resource_group_name = data.terraform_remote_state.setup.outputs.application_rg_name
  profile_name        = azurerm_traffic_manager_profile.traffic_manager.name
  target_resource_id  = data.terraform_remote_state.use2_app_gateway.outputs.use2_app_gateway_ip_id
  type                = "azureEndpoints"
  priority            = 1
}

resource "azurerm_traffic_manager_endpoint" "tx_endpoint" {
  name                = "${local.resource_prefix}-txapp-tm-endpoint"
  resource_group_name = data.terraform_remote_state.setup.outputs.application_rg_name
  profile_name        = azurerm_traffic_manager_profile.traffic_manager.name
  target_resource_id  = data.terraform_remote_state.ussc_app_gateway.outputs.ussc_app_gateway_ip_id
  type                = "azureEndpoints"
  priority            = 2
}

#### monitoring ####
data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_traffic_manager" {
  resource_id = azurerm_traffic_manager_profile.traffic_manager.id
}

resource "azurerm_monitor_diagnostic_setting" "traffic_manager_diag" {
  name                           = "trafficmanager-diag"
  target_resource_id             = azurerm_traffic_manager_profile.traffic_manager.id
  eventhub_name                  = data.terraform_remote_state.setup.outputs.diag_eventhub_name
  eventhub_authorization_rule_id = data.terraform_remote_state.setup.outputs.diag_eventhub_auth_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_traffic_manager.logs
    content {
      category = log.value
      enabled  = true
      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_traffic_manager.metrics

    content {
      category = metric.value
      enabled  = true
      retention_policy {
        enabled = true
      }
    }
  }
}
