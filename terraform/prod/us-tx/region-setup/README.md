# Deploying

This deploys bare minimum resources for additional regions.

# Dependencies

- Azure Tenant/Subscription
- Primary Region setup

## Code updates

- Update regional-vars.tf with proper values

## Code Deployment

`terraform init`

`terraform plan`

`terraform apply`

### State file updates

Open region-setup/tstate.tf and update these values

- resource group
- storage account name
- container name
- environment (usgovernment or public)

```hcl
terraform {
  required_version = ">= 1.1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.91.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "eastus2-mp-tm-management-rg"
    storage_account_name = "eastus2mptmsatfstate"
    container_name       = "eastus2tmtfstatecontainer"
    var.az_environment
    key                  = "tfsetup.tfstate"
  }
}
```

Re-run `terraform init` and migrate the initial local backend to the new remote backend.

## Next steps

mgmt/mgmt-network

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| subscription_id | The Azure subscription ID resources are being deployed into | `string` | n/a | yes |
| location | The Azure location/region to create things in | `string` | n/a | yes |
| resource_prefix | The prefix for the storage account names | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| management_rg_name |  |
| network_rg_name |  |
| key_vault_rg_name |  |
| application_rg_name |  |
| diag_eventhub_name |  |
| diag_eventhub_auth_id |  |
| storage_account_ars_id |  |
| storage_account_ars_name |  |
| storage_account_flowlogs_id |  |
| storage_account_flowlogs_name |  |
| storage_account_vmdiag_id |  |
| storage_account_vmdiag_name |  |
| storage_account_vmdiag_sas |  |
| shellscripts_container_id |  |
| vmdiag_endpoint |  |
