output "aa_id" {
  value = module.va-aa.aa_id
}

output "aa_name" {
  value = module.va-aa.aa_name
}

output "aa_principal_id" {
  value = module.va-aa.aa_principal_id
}

output "aa_dsc_endpoint" {
  value = module.va-aa.aa_dsc_endpoint
}

output "aa_primary_registration" {
  value     = module.va-aa.aa_primary_registration_key
  sensitive = true
}
