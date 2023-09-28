# Region Setup Deployment

This is the second terraform folder that is deployed into the environment.
Region setup will provision basic initial resources.

## Dependencies

- Security Core
- Sign into the Azure Portal and delete the default NetworkWatcher resource group and resources.

## Code updates

If this is the first region the settings in `regional-vars.tf` should have been updated with the security-core deployment. If this is an additional region update these variables as appropriate.

- location
- location_abbreviation
- regional_tags

In the `tstate.tf` file update to the appropriate version and storage accounts.  This configures the remote state file with the storage account in Azure.  See sample below:

``` hcl
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.45.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "prod-va-mp-core-rg"
    storage_account_name = "prodvampsatfstate"
    container_name       = "vatfstatecontainer"
    environment          = "usgovernment"
    key                  = "va-region-setup.tfstate"
  }
}
```

In the `setup.tf` file:

- update the SAS token expiration based on project schedule (if required)
- update Resource Group names (if required)

## Deployment steps

Sign into the portal and delete the default NetworkWatcher resource group and resources.

Change directory to the `region-setup` folder in the primary region

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the execution plan.

Run `terraform apply` to deploy.

**Note**: you may need to re-run the apply due to delays in propagation of Key Vault permissions. You should be able to re-run after a few minutes without issues.

Update the `remote-data.tf` file to add the region state key.  This pulls down the remote variables from the state file. See sample below:

``` hcl
data "terraform_remote_state" "setup" {
  backend = "azurerm"

  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix}-core-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    var.az_environment
    key                  = "${var.location_abbreviation}-region-setup.tfstate"
  }
}
```

After the `mgmt/mgmt-network` is created, uncomment this `sa_virtual_network_subnet_ids` argument, and rerun `terraform apply`

## Created Resources

| Resource | Description |
|------|-------------|
| Resource Group | Application Plane RG |
| Resource Group | Key Vault RG |
| Resource Group | Management Plane |
| Resource Group | Networking RG|
| Storage Account | Azure Recovery Services |
| Storage Account | Cloud Shell |
| Storage Account | NSG Flow Logs |
| Storage Account | Install files |
| Storage Account | VM Diagnostic |
| Storage Account | FedRamp Documents and Artifacts |
| Image Gallery | Shared Image Gallery for future Images |
| Image Definition | RHEL7 golden image definition |
| Image Definition | Windows 2019 golden image definition |
| Image Definition | Windows AD image definition |
| Image Definition | Windows CA image definition |
| Network Watcher | Regional Network Watcher |

## Next steps

Management VNet (terraform/prod/{region}/mgmt/mgmt-network)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| subscription_id | The Azure subscription ID resources are being deployed into | `string` | n/a | yes |
| location | The Azure location/region to create things in | `string` | n/a | yes |
| location_abbreviation | The default Azure location/region to create resources in | `string` | n/a | yes |
| resource_prefix | The prefix for the storage account names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| rhel7_id | ID of the rhel image from image gallery |
| windows_golden_id | ID of the windows image from image gallery |
| windows_ad_id | ID of the AD windows image from the image gallery |
| windows_ca_id | ID of the CA windows image from the image gallery |
| management_rg_name | Management Resource Group Name |
| network_rg_name | Networking Resource Group Name |
| key_vault_rg_name | Key Vault Resource Group Name |
| key_vault_rg_id | Key Vault Resource Group ID |
| application_rg_name | Application Resource Group Name |
| storage_account_ars_id | Azure Site Recovery Storage Account ID |
| storage_account_ars_name | Azure Site Recovery Storage Account Name |
| storage_account_flowlogs_id | NSG Flow Logs Storage Account ID |
| storage_account_flowlogs_name | NSG Flow Logs Storage Account Name |
| storage_account_install_id | Install files Storage Account ID |
| storage_account_install_name | Install files Storage Account Name |
| storage_account_docs_id | FedRAMP Docs and Artifacts Storage Account ID |
| storage_account_docs_name | FedRAMP Docs and Artifacts Storage Account Name |
| installs_container_id | SA container for Install Files ID |
| installs_container_name | SA container for Install Files Name |
| storage_account_vmdiag_id | VM Diagnostic Data Storage Account ID |
| storage_account_vmdiag_name | VM Diagnostic Data Storage Account Name |
| storage_account_vmdiag_sas | VM Diagnostic Storage Account SAS token |
| shellscripts_container_id | SA container for shellscripts ID |
| vmdiag_endpoint | Storage account where VM Diag logs are stored |
| network_watcher_name | Name for Azure Network Watcher Service |
| additional_resource_groups | Map with additional resource groups with format `{name = id}` |
