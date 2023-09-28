# Azure Automation Deployment

This folder creates an Azure Automation Account, uploads the 'Set-VMRunningState.ps1' (located in /shellscripts/windows) to the account as a runbook.

This is for auto startup/shutdown of VM's based on tags. Time provided should be in EST.

The Automation account is also used for host maintenance/upgrades and DSC deployments.  

CMS will use this Automation Account to update Windows and Linux VMs via Update Management.  They will have to develop an update schedule with the client based off of agreed upon downtimes.

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
      version = "= 3.45.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "v1-prod-va-mp-core-rg"
    storage_account_name = "v1prodvampsatfstate"
    container_name       = "vav1tfstatecontainer"
    var.az_environment
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

CMS will have to develop an update schedule with the client based upon the agreed upon downtimes.

Deployment Steps:

1. Go to the Automation Account in the portal
2. Click 'Update Management'
3. Click 'Enable' and refresh the webpage 
4. Click 'Manage Computers'
5. Check the box to 'Enable on all available and future machines'

Update Management Configuration
![UpdateManagement](https://github.com/Coalfire-CF/trend-micro-vision-one/blob/vm_updates/terraform/prod/us-va/mgmt/azure-automation/UpdateManagement.png?raw=true)

## Created Resources

| Resource | Description |
|------|-------------|
| Automation Account | Automation account for running scripts, DSC policies and patching |
| Runbook | Set-VMRunningState PowerShell script |

## Stopinator

VM's need to have the appropriate tags

Stopinator: true
AutoShutdown: (24hr time)
AutoStartup: (24hr time)

## Next steps

Active Directory Automation (azure/terraform/prod/us-va/mgmt/aa-ad)

## Outputs

| Name | Description |
|------|-------------|
| usgv_aa_name | Name of the Automation Account |
| usgv_aa_id | ID of the Automation Account |
| usgv_aa_principal_id | The Principal ID associated with the Managed Service Identity of the Automation Account |
| usgv_aa_dsc_endpoint | DSC Server endpoint of the Automation Account |
| usgv_aa_primary_registration | Registration Key for Automation Account |
