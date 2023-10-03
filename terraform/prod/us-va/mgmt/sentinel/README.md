# Sentinel 

Creates Sentinel on the management plan log analytics workspace

## Dependencies

- Security Core
- Region Setup

## Code updates

`sentinel.tf`

- Update the variables as needed

`tstate.tf` Update to the appropriate version and storage accounts, see sample

```hcl
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
    key                  = "va-mgmt-sentinel.tfstate"
  }
}
```

## Deployment steps

Change directory to the `mgmt/sentinel` folder in the primary region

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the plan is expected.

Run `terraform apply` to deploy.

Update the `remote-data.tf` file to add the region setup state key

Rerun `terraform apply` to update all changes