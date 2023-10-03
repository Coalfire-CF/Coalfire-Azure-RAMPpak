output "management_rg_name" {
  value = module.setup.management_rg_name
}

output "network_rg_name" {
  value = module.setup.network_rg_name
}

output "key_vault_rg_name" {
  value = module.setup.key_vault_rg_name
}

output "key_vault_rg_id" {
  value = module.setup.key_vault_rg_id
}

output "application_rg_name" {
  value = module.setup.application_rg_name
}

output "storage_account_ars_id" {
  value = module.setup.storage_account_ars_id
}

output "storage_account_ars_name" {
  value = module.setup.storage_account_ars_name
}

output "storage_account_flowlogs_id" {
  value = module.setup.storage_account_flowlogs_id
}

output "storage_account_flowlogs_name" {
  value = module.setup.storage_account_flowlogs_name
}

output "storage_account_install_id" {
  value = module.setup.storage_account_install_id
}

output "storage_account_install_name" {
  value = module.setup.storage_account_install_name
}

output "storage_account_docs_id" {
  value = module.setup.storage_account_docs_id
}

output "storage_account_docs_name" {
  value = module.setup.storage_account_docs_name
}

output "installs_container_id" {
  value = module.setup.installs_container_id
}

output "installs_container_name" {
  value = module.setup.installs_container_name
}
output "storage_account_vmdiag_id" {
  value = module.setup.storage_account_vmdiag_id
}

output "storage_account_vmdiag_name" {
  value = module.setup.storage_account_vmdiag_name
}

output "storage_account_vmdiag_sas" {
  sensitive = true
  value     = module.setup.storage_account_vm_diag_sas
}

output "shellscripts_container_id" {
  value = module.setup.shellscripts_container_id
}

output "vmdiag_endpoint" {
  value = module.setup.vmdiag_endpoint
}

output "network_watcher_name" {
  value = module.setup.network_watcher_name
}

output "usgv_additional_resource_groups" {
  value = module.setup.additional_resource_groups
}
