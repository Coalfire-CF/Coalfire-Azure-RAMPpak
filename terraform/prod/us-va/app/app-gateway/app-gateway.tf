
resource "azurerm_user_assigned_identity" "va-agw-mid" {
  resource_group_name = data.terraform_remote_state.setup.outputs.application_rg_name
  location            = var.location

  name = "${local.resource_prefix}-app-mi"

  tags = merge({
    Function = "Managed Identity"
    Plane    = "Application"
  }, var.global_tags, var.regional_tags)
}

resource "azurerm_role_assignment" "umid-keyvault" {
  scope                = data.terraform_remote_state.key_vaults.outputs.use2_app_kv_id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = azurerm_user_assigned_identity.va-agw-mid.principal_id
}

resource "azurerm_role_assignment" "umid-keyvault2" {
  scope                = data.terraform_remote_state.key_vaults.outputs.use2_app_kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.va-agw-mid.principal_id
}

#  This is the temporary/place holder certificate
# data "azurerm_key_vault_secret" "ssl_cert" {
#   name         = "appgateway"
#   key_vault_id = data.terraform_remote_state.key_vaults.outputs.use2_app_kv_id
# }

#  This assumes that a valid EV Certificate for the go-to-market FQDN is present in Key Vault
data "azurerm_key_vault_secret" "go_to_market_ssl_cert" {
  name         = "frontendSSL"
  key_vault_id = data.terraform_remote_state.key_vaults.outputs.use2_app_kv_id
}

resource "azurerm_public_ip" "va-appgw-pip" {
  name                = "${local.resource_prefix}-appgw-pip"
  resource_group_name = data.terraform_remote_state.setup.outputs.application_rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "standard"
  domain_name_label   = "${local.resource_prefix}-appgw-pip"
}

# these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name       = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-beap"
  frontend_port_name_https        = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-feport443"
  frontend_port_name_http         = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-feport80"
  frontend_ip_configuration_name  = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-feip"
  http_setting_name               = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-be-htst"
  listener_name_https             = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-httpslstn"
  listener_name_http              = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-httplstn"
  request_routing_rule_name_https = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-rqrt443"
  request_routing_rule_name_http  = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-rqrt80"
  redirect_configuration_name     = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-rdrcfg"
  health_probe_name               = "${data.terraform_remote_state.use2_mgmt_vnet.outputs.use2_mgmt_vnet_name}-hp"
  health_probe_hostname           = "openedms.com" #  There is probably a better place to put this
}

resource "azurerm_application_gateway" "va-appgw" {
  name                = "${local.resource_prefix}-app-agw"
  resource_group_name = data.terraform_remote_state.setup.outputs.application_rg_name
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
    name                = "openedms.com"
    key_vault_secret_id = data.azurerm_key_vault_secret.go_to_market_ssl_cert.id
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection" #Prevention
    rule_set_type    = "OWASP"
    rule_set_version = "3.1"
  }


  identity {
    identity_ids = [azurerm_user_assigned_identity.va-agw-mid.id]
  }

  gateway_ip_configuration {
    name      = "gatewayipconfig"
    subnet_id = data.terraform_remote_state.mgmt-vnet.outputs.vnet_subnets["${local.resource_prefix}-public-sn-1"]
  }

  frontend_port {
    name = local.frontend_port_name_https
    port = 443
  }

  frontend_port {
    name = local.frontend_port_name_http
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.va-appgw-pip.id
  }

  #  It is not currently possible to set the Backend Pool to use a 
  #      Virtual Machine as is currently set in the Azure Portal.
  #      Thus, it will need to be done manually.
  backend_address_pool {
    name = local.backend_address_pool_name
    ip_addresses = [
      data.terraform_remote_state.app1.outputs.app1_ip[0]
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
    name                           = local.listener_name_https
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_https
    protocol                       = "Https"
    ssl_certificate_name           = "openedms.com"
  }

  http_listener {
    name                           = local.listener_name_http
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_http
    protocol                       = "Http"
    ssl_certificate_name           = "openedms.com"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name_https
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name_https
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  redirect_configuration {
    name                 = local.redirect_configuration_name
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = local.listener_name_https
  }

  request_routing_rule {
    name                        = local.request_routing_rule_name_http
    rule_type                   = "Basic"
    http_listener_name          = local.listener_name_http
    redirect_configuration_name = local.redirect_configuration_name
  }

  probe {
    name                = local.health_probe_name
    host                = local.health_probe_hostname
    interval            = 30
    protocol            = "Https"
    path                = "/"
    timeout             = 30
    unhealthy_threshold = 3
  }

  tags = merge(var.appgateway_tags, var.regional_tags, var.global_tags)
}
