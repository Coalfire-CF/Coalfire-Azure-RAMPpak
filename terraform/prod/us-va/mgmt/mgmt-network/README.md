# Management Network Deployment

This deploys the Management VNet and it's subnets

## Dependencies

- Security Core
- Region Setup

## Code updates

`mgmt.tf`

- Update the name and number of subnets as needed in the `subnet_addrs` module.
- If you need to add or remove Service Endpoints, do so in the `subnet_service_endpoints` block. See <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet> for Service Endpoint options.


`tstate.tf` Update to the appropriate version and storage accounts, see sample

```hcl
terraform {
  required_version = ">= 1.5.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.61.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "prod-va-mp-core-rg"
    storage_account_name = "prodvampsatfstate"
    container_name       = "vatfstatecontainer"
    environment          = "usgovernment"
    key                  = "va-mgmt-network.tfstate"
  }
}
```

## Deployment steps

Change directory to the `mgmt/mgmt-network` folder in the primary region

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the plan is expected.

Run `terraform apply` to deploy.

Update the `remote-data.tf` file to add the region setup state key

Rerun `terraform apply` to update all changes

## Created Resources

| Resource | Description |
|------|-------------|
| Virtual Network | |
| Subnet | Public /24 network |
| Subnet | IAM /24 network |
| Subnet | CICD /24 network |
| Subnet | SecOps /24 network |
| Subnet | SIEM /24 network |
| Subnet | Monitor /24 network |
| Subnet | Bastion /24 network |
| Subnet | AzureFirewallsubnet /24 network |
| Subnet | Private Endpoint /24 network |
| Subnet | PostgreSQL /24 network |


## Next steps

Application VNet (terraform/prod/{region}/app/app-network)
