# output "rhel7_id" {
#   value = module.setup.rhel7_id
# }

# output "windows_golden_id" {
#   value = module.setup.windows_golden_id
# }

# output "windows_ad_id" {
#   value = module.setup.windows_ad_id
# }

# output "windows_ca_id" {
#   value = module.setup.windows_ca_id
# }
output "management_rg_name" {
  value = module.setup.management_rg_name
}

output "network_rg_name" {
  value = module.setup.network_rg_name
}

output "key_vault_rg_name" {
  value = module.setup.key_vault_rg_name
}

output "application_rg_name" {
  value = module.setup.application_rg_name
}

output "diag_eventhub_name" {
  value = module.setup.eventhub_name
}

output "diag_eventhub_auth_id" {
  value = module.setup.eventhub_auth_id
}

# output "storage_account_ars_id" {
#   value = module.setup.storage_account_ars_id
# }

# output "storage_account_ars_name" {
#   value = module.setup.storage_account_ars_name
# }

output "storage_account_flowlogs_id" {
  value = module.setup.storage_account_flowlogs_id
}

output "storage_account_flowlogs_name" {
  value = module.setup.storage_account_flowlogs_name
}

# output "storage_account_install_id" {
#   value = module.setup.storage_account_install_id
# }

# output "storage_account_install_name" {
#   value = module.setup.storage_account_install_name
# }

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

# output "shellscripts_container_id" {
#   value = module.setup.shellscripts_container_id
# }

# output "storage_account_tfstate_id" {
#   value = module.setup.storage_account_tfstate_id
# }

# output "storage_account_tfstate_name" {
#   value = module.setup.storage_account_tfstate_name
# }

output "vmdiag_endpoint" {
  value = module.setup.vmdiag_endpoint
}

output "network_watcher_name" {
  value = module.setup.network_watcher_name
}
