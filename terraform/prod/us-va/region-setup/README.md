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
    environment          = var.az_environment
    key                  = "${var.location_abbreviation}-region-setup.tfstate"
  }
}
```

After the `mgmt/mgmt-network` is created, uncomment this `firewall_vnet_subnet_ids` argument, and rerun `terraform apply`

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
| Network Watcher | Regional Network Watcher |

## Next steps

Management VNet (terraform/prod/{region}/mgmt/mgmt-network)
