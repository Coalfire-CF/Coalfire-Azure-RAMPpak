resource "azurerm_role_assignment" "ad_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.ad_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "ad_kv_certs_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.ad_kv.key_vault_id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "dj_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.domain_join_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "nessus_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.nessus_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "appsec_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.appsec_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "burp_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.burp_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "grafana_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.grafana_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "github_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.github_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "key_vault_rg_owner" {
  for_each             = var.admin_principal_ids
  scope                = data.terraform_remote_state.setup.outputs.key_vault_rg_id
  role_definition_name = "Owner"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "jira_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.jira_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "tower_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.tower_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "certs_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.certs_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "certs_kv_certs_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.certs_kv.key_vault_id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "jenkins_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.jenkins_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}