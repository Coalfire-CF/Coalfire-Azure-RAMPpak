output "usgv_ad_kv_uri" {
  value       = module.ad_kv.key_vault_uri
  description = "URI of the Active Directory Key Vault"
}

output "usgv_ad_kv_name" {
  value       = module.ad_kv.key_vault_name
  description = "Name of the Active Directory Key Vault"
}

output "usgv_ad_kv_id" {
  value       = module.ad_kv.key_vault_id
  description = "ID of the Active Directory Key Vault"
}

output "usgv_certs_kv_uri" {
  value       = module.certs_kv.key_vault_uri
  description = "URI of the Certificates Key Vault"
}

output "usgv_certs_kv_name" {
  value       = module.certs_kv.key_vault_name
  description = "Name of the Certificates Key Vault"
}

output "usgv_certs_kv_id" {
  value       = module.certs_kv.key_vault_id
  description = "ID of the Certificates Key Vault"
}
