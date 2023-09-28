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

resource "azurerm_role_assignment" "key_vault_rg_owner" {
  for_each             = var.admin_principal_ids
  scope                = data.terraform_remote_state.setup.outputs.key_vault_rg_id
  role_definition_name = "Owner"
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
