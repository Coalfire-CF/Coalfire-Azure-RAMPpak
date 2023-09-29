# Azure Automation Deployment

This folder creates an Azure Automation Account.

The Automation account is used for host maintenance/upgrades and DSC deployments.

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
    key                  = "va-az-automation.tfstate"
  }
}
```

`automation.tf`
Should need no changes.

## Deployment Steps

Change directory to the `azure-automation` folder

Run `terraform init` to download modules and create initial local state file.

Run `terraform plan` to ensure no errors and validate plan is deploying expected resources.

Run `terraform apply` to deploy infrastructure.

Update the `remote-data.tf` file to add the security state key

``` hcl
data "terraform_remote_state" "usgv-az-automation" {
  backend = "azurerm"
  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix}-core-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = var.az_environment
    key                  = "${var.location_abbreviation}-az-automation.tfstate"
  }
}
```

Run `terraform apply` again to update the remote state file in Azure.

## Post Deployment Steps - Enable Update Management

After a successful deployment of the Azure Automation account Update Management will need to be turned on for all virtual machines (both Linux and Windows).  This is currently only possible via the portal until [azurerm 4.0.0](https://github.com/hashicorp/terraform-provider-azurerm/issues/2812) comes out.

Deployment Steps:

1. Go to the Automation Account in the portal
2. Click 'Update Management'
3. Click 'Enable' and refresh the webpage 
4. Click 'Manage Computers'
5. Check the box to 'Enable on all available and future machines'

## Created Resources

| Resource | Description |
|------|-------------|
| Automation Account | Automation account for patching |

## Next steps

Bastions `terraform/prod/us-va/mgmt/bastion`
