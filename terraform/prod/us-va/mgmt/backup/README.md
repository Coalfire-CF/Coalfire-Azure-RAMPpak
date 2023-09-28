# Backup

Sets up an Azure recovery vault.

## Dependencies

- Security Core
- Region Setup

## Code Updates

`tstate.tf` Update to the appropriate version and storage accounts, see sample

``` hcl
terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "v1-prod-va-mp-core-rg"
    storage_account_name = "v1prodvampsatfstate"
    container_name       = "vav1tfstatecontainer"
    var.az_environment
    key                  = "va-backup.tfstate"
  }
}
```

## Deployment Steps

Change directory to the `backup` folder

Run `terraform init` to download modules and create initial local state file.

Run `terraform plan` to ensure no errors and validate plan is deploying expected resources.

Run `terraform apply` to deploy infrastructure.

Update the `remote-data.tf` file to add the security state key

``` hcl
data "terraform_remote_state" "usgv-backup" {
  backend = "azurerm"
  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix}-core-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    var.az_environment
    key                  = "${var.location_abbreviation}-backup.tfstate"
  }
}
```

## Additional Information

The policy will only be applied to virtual machines that have the tag `BackupPolicy: backupvm_default_policy` on the associated subscriptions.

## Created Resources

| Resource | Description |
|------|-------------|
| azurerm_recovery_services_vault | Azure Recovery Services Vault to backup virtual machines |
| azurerm_backup_policy_vm | Default Azure Backup VM Backup Policy |
| Diagnostic settings | Diagnostic Setting for the newly created recovery vault | 

## Next steps

None

## Outputs

| Name | Description |
|------|-------------|
| usgv_mgmt_recovery_vault_id | The ID of the Recovery Services Vault |
| usgv_mgmt_backupvm_default_policy_name | The Name of the VM backup default policy |
| usgv_mgmt_backupvm_default_policy_id | The ID of the VM backup default policy |
| usgv_mgmt_backupvm_tag_key | Tag key to attach backup vm default policy. In other words, VMs with this key/value tag will be backed up by the default backup vm policy | 
| usgv_mgmt_backupvm_tag_value | Tag value to attach backup vm default policy. In other words, VMs with this key/value tag will be backed up by the default backup vm policy | 
