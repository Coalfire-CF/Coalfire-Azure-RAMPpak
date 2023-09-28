# VNet Peering

This enables peering between the Management Plane and Application Plane Virtual Networks.

## Dependencies

- Application VNet
- Management VNet

## Code updates

`vnet-peering.tf`
This file should require no changes unless

- VNet peering is *not* used in this build
- There are additional VNets that need peering

`tstate.tf` Update to the appropriate version and storage accounts, see sample

``` hcl
terraform {
  required_version = "~>1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.61.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "ex-prod-va-mp-core-rg"
    storage_account_name = "exprodvampsatfstate"
    container_name       = "vaextfstatecontainer"
    environment          = "usgovernment"
    key                  = "va-vnet-peering.tfstate"
  }
}
```

## Deployment steps

Change directory to the `mgmt/vnet-peering` folder in the primary region.

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the plan is expected.

Run `terraform apply` to deploy.

Update the `remote-data.tf` file to add the region setup state key, see sample.

``` hcl
data "terraform_remote_state" "usgv_peering" {
  backend = "azurerm"

  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix}-core-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-vnet-peering.tfstate"
  }
}
```

## Created Resources

| Resource | Description |
|------|-------------|
| VNet Peering | Connection between the management and application virtual networks. |

## Next Steps

Key Vault Deployment `terraform/prod/{region}/mgmt/key-vault`
