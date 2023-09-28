module "custom_policies_mgmt" {
  source = "../../../../modules/coalfire-microsoft-defender"
  providers = {
    azurerm = azurerm.mgmt
  }
  subscription_id       = lookup(local.subscription_ids, "mgmt")
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
}

module "custom_policies_ath" {
  source = "../../../../modules/coalfire-microsoft-defender"
  providers = {
    azurerm = azurerm.ath
  }
  subscription_id       = lookup(local.subscription_ids, "ath")
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
}

module "custom_policies_awb" {
  source = "../../../../modules/coalfire-microsoft-defender"
  providers = {
    azurerm = azurerm.awb
  }
  subscription_id       = lookup(local.subscription_ids, "awb")
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
}

module "custom_policies_sae" {
  source = "../../../../modules/coalfire-microsoft-defender"
  providers = {
    azurerm = azurerm.sae
  }
  subscription_id       = lookup(local.subscription_ids, "sae")
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
}

module "custom_policies_spark" {
  source = "../../../../modules/coalfire-microsoft-defender"
  providers = {
    azurerm = azurerm.spark
  }
  subscription_id       = lookup(local.subscription_ids, "spark")
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
}

module "custom_policies_v1platform" {
  source = "../../../../modules/coalfire-microsoft-defender"
  providers = {
    azurerm = azurerm.v1platform
  }
  subscription_id       = lookup(local.subscription_ids, "v1platform")
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
}

module "custom_policies_psd" {
  source = "../../../../modules/coalfire-microsoft-defender"
  providers = {
    azurerm = azurerm.psd
  }
  subscription_id       = lookup(local.subscription_ids, "psd")
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
}

module "custom_policies_sdl" {
  source = "../../../../modules/coalfire-microsoft-defender"
  providers = {
    azurerm = azurerm.sdl
  }
  subscription_id       = lookup(local.subscription_ids, "sdl")
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
}

module "custom_policies_edl" {
  source = "../../../../modules/coalfire-microsoft-defender"
  providers = {
    azurerm = azurerm.edl
  }
  subscription_id       = lookup(local.subscription_ids, "edl")
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
}