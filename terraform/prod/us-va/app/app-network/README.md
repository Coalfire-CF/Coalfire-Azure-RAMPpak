# Application Network Deployment

This deploys the Application Plane Vnet and it's subnets

## Dependencies

- Security Core
- Region Setup

## Code updates

`app.tf`

- Update the name and number of subnets as needed in the `subnet_addrs` module.
- If you need to add or remove Service Endpoints, do so in the `subnet_service_endpoints` block. See <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> for Service Endpoint options.

`tstate.tf` Update to the appropriate version and storage accounts, see sample

``` hcl
terraform {
  required_version = ">= 1.1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.91.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "ex-prod-va-mp-core-rg"
    storage_account_name = "exprodvampsatfstate"
    container_name       = "vaextfstatecontainer"
    environment          = "usgovernment"
    key                  = "va-app-network.tfstate"
  }
}
```

## Deployment steps

Change directory to the `app/app-network` folder in the primary region

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the plan is expected.

Run `terraform apply` to deploy.

Update the `remote-data.tf` file to add the application setup state key. See sample.

``` hcl
data "terraform_remote_state" "usgv_app_vnet" {
  backend = "azurerm"

  config = {
    storage_account_name = "${var.location_abbreviation}mp${var.app_abbreviation}satfstate"
    resource_group_name  = "${var.location_abbreviation}-mp-${var.app_abbreviation}-core-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    var.az_environment
    key                  = "use2-app-vnet.tfstate"
  }
}
```

## Created Resources

| Resource | Description |
|------|-------------|
| Virtual Network | Application Plane /16 network |
| Subnet | DMZ /24 network |
| Subnet | edge /24 network |
| Subnet | backend /24 network |

## Next steps

Enable VNet peering between the Management Plane and Application Plane VNet's. (mgmt/vnet-peering)

## Outputs

| Name | Description |
|------|-------------|
| usgv_app_vnet_id | The id of the application vnet |
| usgv_app_vnet_name | The name of the application vnet |
| usgv_app_vnet_subnet_ids | The ids of subnets created inside the new vnet |
