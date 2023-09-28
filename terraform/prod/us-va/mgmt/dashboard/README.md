# Azure Portal Dashboard

Deploys shared dashboards for monitoring the current state of the environment.

## Dependencies

- Secure Core
- Region Setup

## Resource List

- Inventory Dashboard

## Code updates

`tstate.tf` Update to the appropriate version and storage accounts, see sample

```hcl
terraform {
  required_version = "1.3.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.45.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "v1-prod-va-mp-core-rg"
    storage_account_name = "v1prodvampsatfstate"
    container_name       = "vav1tfstatecontainer"
    environment          = "usgovernment"
    key                  = "va_dashboard.tfstate"
  }
}
```

## Deployment steps

Change directory to the `mgmt/dashboard` folder in the primary region

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the plan is expected.

Run `terraform apply` to deploy.


## Additional Information
- When adding new dashboards, it is recommended to follow the steps outlined [here](https://docs.microsoft.com/azure/azure-portal/azure-portal-dashboards-create-programmatically#fetch-the-json-representation-of-the-dashboard) to create a Dashboard in the Portal and extract the relevant JSON to use in this resource.
- When adding new dashboards, make sure the template json files only include the `lenses` and `metadata` properties/objects otherwise the deployment will fail. Look at inventory dashboard as an example.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|

## Outputs

| Name | Description |
|------|-------------|