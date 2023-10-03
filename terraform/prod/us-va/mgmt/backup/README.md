# Backup

Sets up an Azure recovery vault.

## Dependencies

- Security Core
- Region Setup

## Code Updates

`tstate.tf` Update to the appropriate version and storage accounts, see sample

``` hcl
terraform {
  required_version = "~>1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "ex-prod-va-mp-core-rg"
    storage_account_name = "exprodvampsatfstate"
    container_name       = "vaextfstatecontainer"
    environment          = "usgovernment"
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
    environment          = var.az_environment
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

Sentinel `terraform/prod/us-va/mgmt/sentinel`