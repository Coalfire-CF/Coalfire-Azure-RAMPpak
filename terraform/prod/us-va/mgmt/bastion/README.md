# Bastion

Deploy a windows server in boundary to access the management and application infrastructure.

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
    key                  = "va-bastion.tfstate"
  }
}
```

## Deployment Steps

Change directory to the `bastion` folder

Run `terraform init` to download modules and create initial local state file.

Run `terraform plan` to ensure no errors and validate plan is deploying expected resources.

Run `terraform apply` to deploy infrastructure.

Update the `remote-data.tf` file to add the security state key

``` hcl
data "terraform_remote_state" "usgv-bastion" {
  backend = "azurerm"
  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix}-core-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-bastion.tfstate"
  }
}
```

If you experience the error `Microsoft.Compute/EncryptionAtHost' feature is not enabled for this subscription.` enable encryption on host by running

```
az feature register --namespace Microsoft.Compute --name EncryptionAtHost
```

## Next Steps

None
