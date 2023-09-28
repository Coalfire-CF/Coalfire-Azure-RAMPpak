resource "azurerm_user_assigned_identity" "ussc-agw-mid" {
  resource_group_name = data.terraform_remote_state.ussc-setup.outputs.application_rg_name
  location            = var.location

  name = "${var.location_abbreviation}-mp-${var.app_abbreviation}-app-agw-mid"
}

resource "azurerm_role_assignment" "umid-keyvault" {
  scope                = data.terraform_remote_state.key_vaults.outputs.use2_app_kv_id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = azurerm_user_assigned_identity.ussc-agw-mid.principal_id
}

resource "azurerm_role_assignment" "umid-keyvault2" {
  scope                = data.terraform_remote_state.key_vaults.outputs.use2_app_kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.ussc-agw-mid.principal_id
}

#  This is the temporary/place holder certificate
# data "azurerm_key_vault_secret" "ssl_cert" {
#   name         = "appgateway"
#   key_vault_id = data.terraform_remote_state.key_vaults.outputs.use2_app_kv_id
# }

#  This assumes that a valid EV Certificate for the go-to-market FQDN is present in Key Vault
data "azurerm_key_vault_secret" "go_to_market_ssl_cert" {
  name         = "cloudgov"
  key_vault_id = data.terraform_remote_state.key_vaults.outputs.use2_app_kv_id
}

resource "azurerm_public_ip" "ussc-appgw-pip" {
  name                = "${var.location_abbreviation}-mp-${var.app_abbreviation}-app-agw-pip"
  resource_group_name = data.terraform_remote_state.ussc-setup.outputs.application_rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "standard"
  domain_name_label   = "${var.location_abbreviation}-mp-${var.app_abbreviation}-app-agw-pip"
}

# these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name}-beap"
  frontend_port_name             = "${data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name}-feport"
  frontend_ip_configuration_name = "${data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name}-feip"
  http_setting_name              = "${data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name}-be-htst"
  listener_name                  = "${data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name}-httplstn"
  request_routing_rule_name      = "${data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name}-rqrt"
  redirect_configuration_name    = "${data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name}-rdrcfg"
  health_probe_name              = "${data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_name}-hp"
  health_probe_hostname          = "cloudgov.com" #  There is probably a better place to put this
}

resource "azurerm_application_gateway" "ussc-appgw" {
  name                = "${var.location_abbreviation}-mp-${var.app_abbreviation}-app-agw"
  resource_group_name = data.terraform_remote_state.ussc-setup.outputs.application_rg_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  # ssl_certificate {
  #   name                = "appgatewal"
  #   key_vault_secret_id = data.azurerm_key_vault_secret.ssl_cert.id
  # }

  ssl_certificate {
    name                = "cloudgov.com"
    key_vault_secret_id = data.azurerm_key_vault_secret.go_to_market_ssl_cert.id
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.1"
  }


  identity {
    identity_ids = [azurerm_user_assigned_identity.ussc-agw-mid.id]
  }
  gateway_ip_configuration {
    name      = "gatewayipconfig"
    subnet_id = data.terraform_remote_state.ussc_app_vnet.outputs.ussc_app_vnet_subnet_ids[0]
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ussc-appgw-pip.id
  }

  #  It is not currently possible to set the Backend Pool to use a 
  #      Virtual Machine as is currently set in the Azure Portal.
  #      Thus, it will need to be done manually.
  backend_address_pool {
    name = local.backend_address_pool_name
    ip_addresses = [
      data.terraform_remote_state.ussc_web.outputs.ussc_web1_ip[0],
      data.terraform_remote_state.ussc_web.outputs.ussc_web2_ip[0]
    ]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 443
    probe_name            = local.health_probe_name
    protocol              = "Https"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = "cloudgov.com"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  probe {
    name                = local.health_probe_name
    host                = local.health_probe_hostname
    interval            = 30
    protocol            = "Https"
    path                = "/azurelaunchpad"
    timeout             = 30
    unhealthy_threshold = 3
  }
}

#### monitoring ####
data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_app_gateway" {
  resource_id = azurerm_application_gateway.ussc-appgw.id
}

resource "azurerm_monitor_diagnostic_setting" "app_gateway_diag" {
  name                           = "appgateway-diag"
  target_resource_id             = azurerm_application_gateway.ussc-appgw.id
  eventhub_name                  = data.terraform_remote_state.ussc-setup.outputs.diag_eventhub_name
  eventhub_authorization_rule_id = data.terraform_remote_state.ussc-setup.outputs.diag_eventhub_auth_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_app_gateway.logs
    content {
      category = log.value
      enabled  = true
      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_app_gateway.metrics

    content {
      category = metric.value
      enabled  = true
      retention_policy {
        enabled = true
      }
    }
  }
}
