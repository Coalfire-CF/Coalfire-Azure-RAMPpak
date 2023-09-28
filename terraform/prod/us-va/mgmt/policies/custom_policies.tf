module "custom_policies_mgmt" {
  source = "../../../../modules/coalfire-custom-policies"
  providers = {
    azurerm = azurerm.mgmt
  }
  resource_prefix           = "mgmt"
  location                  = var.location
  user_assigned_identity_id = azurerm_user_assigned_identity.policies.id
  subscription_id           = lookup(local.subscription_ids, "mgmt")
  backupvm = {
    tag_key   = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_key
    tag_value = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_value
    policy_id = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_default_policy_id
  }
}

module "custom_policies_ath" {
  source = "../../../../modules/coalfire-custom-policies"
  providers = {
    azurerm = azurerm.ath
  }
  resource_prefix           = "ath"
  location                  = var.location
  user_assigned_identity_id = azurerm_user_assigned_identity.policies.id
  subscription_id           = lookup(local.subscription_ids, "ath")
  backupvm = {
    tag_key   = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_key
    tag_value = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_value
    policy_id = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_default_policy_id
  }
}

module "custom_policies_awb" {
  source = "../../../../modules/coalfire-custom-policies"
  providers = {
    azurerm = azurerm.awb
  }
  resource_prefix           = "awb"
  location                  = var.location
  user_assigned_identity_id = azurerm_user_assigned_identity.policies.id
  subscription_id           = lookup(local.subscription_ids, "awb")
  backupvm = {
    tag_key   = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_key
    tag_value = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_value
    policy_id = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_default_policy_id
  }
}

module "custom_policies_sae" {
  source = "../../../../modules/coalfire-custom-policies"
  providers = {
    azurerm = azurerm.sae
  }
  resource_prefix           = "sae"
  location                  = var.location
  user_assigned_identity_id = azurerm_user_assigned_identity.policies.id
  subscription_id           = lookup(local.subscription_ids, "sae")
  backupvm = {
    tag_key   = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_key
    tag_value = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_value
    policy_id = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_default_policy_id
  }
}

module "custom_policies_spark" {
  source = "../../../../modules/coalfire-custom-policies"
  providers = {
    azurerm = azurerm.spark
  }
  resource_prefix           = "spark"
  location                  = var.location
  user_assigned_identity_id = azurerm_user_assigned_identity.policies.id
  subscription_id           = lookup(local.subscription_ids, "spark")
  backupvm = {
    tag_key   = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_key
    tag_value = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_value
    policy_id = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_default_policy_id
  }
}

module "custom_policies_v1platform" {
  source = "../../../../modules/coalfire-custom-policies"
  providers = {
    azurerm = azurerm.v1platform
  }
  resource_prefix           = "v1platform"
  location                  = var.location
  user_assigned_identity_id = azurerm_user_assigned_identity.policies.id
  subscription_id           = lookup(local.subscription_ids, "v1platform")
  backupvm = {
    tag_key   = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_key
    tag_value = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_value
    policy_id = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_default_policy_id
  }
}

module "custom_policies_psd" {
  source = "../../../../modules/coalfire-custom-policies"
  providers = {
    azurerm = azurerm.psd
  }
  resource_prefix           = "psd"
  location                  = var.location
  user_assigned_identity_id = azurerm_user_assigned_identity.policies.id
  subscription_id           = lookup(local.subscription_ids, "psd")
  backupvm = {
    tag_key   = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_key
    tag_value = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_value
    policy_id = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_default_policy_id
  }
}

module "custom_policies_sdl" {
  source = "../../../../modules/coalfire-custom-policies"
  providers = {
    azurerm = azurerm.sdl
  }
  resource_prefix           = "sdl"
  location                  = var.location
  user_assigned_identity_id = azurerm_user_assigned_identity.policies.id
  subscription_id           = lookup(local.subscription_ids, "sdl")
  backupvm = {
    tag_key   = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_key
    tag_value = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_value
    policy_id = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_default_policy_id
  }
}

module "custom_policies_edl" {
  source = "../../../../modules/coalfire-custom-policies"
  providers = {
    azurerm = azurerm.edl
  }
  resource_prefix           = "edl"
  location                  = var.location
  user_assigned_identity_id = azurerm_user_assigned_identity.policies.id
  subscription_id           = lookup(local.subscription_ids, "edl")
  backupvm = {
    tag_key   = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_key
    tag_value = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_tag_value
    policy_id = data.terraform_remote_state.usgv_backup.outputs.usgv_mgmt_backupvm_default_policy_id
  }
}