# Security Core

See the module README for additional information. And deployment steps.

## Description

This is the first IaC component required for deploying the Coalfire Azure FedRAMP Moderate tooling and the associated security management plane. The 'security-core' is a dependency for all other IaC deployment components..

## Resource List

- VNet
- Primary Log Analytics Workspace
- Key Vault for CMK's
- Storage Account for Terraform State
- Diagnostic logs for Subscriptions
- Bootstrapping of Admin IAM

## Code Updates

`global_vars.tf` - ensure variables are updated for appropriate values for

- az_environment
- subscription_id
- tenant_id
- app_subscription_ids
- app_abbreviation
- cidrs_for_remote_access
- admin_principal_ids

## Deployment Steps

Once the code updates are completed and the `core.tf` file is updated with the appropriate values, the following steps are required to deploy the security core folder.

1. `terraform init`
2. `terraform plan`
3. `terraform apply`

Once a successful `apply` is completed. You will need to migrate the terraform state from the local one to the remote storage account. This is required to ensure that the state is not lost if the local machine is destroyed and for cross collaboration between engineers.

**NOTE**: In previous versions of the `security-core` module, `ResourceGroupNotFound` errors would occasionally be encountered when running `terraform apply` for the first time. This behavior was due to a number of resources referencing the Core Resource Group before it was created. ACE-Azure-SecurityCore v1.0.2 introduced dependency fixes which should resolve these errors. However, if you receive a `Code="ResourceGroupNotFound"` error, you may safely invoke `terraform apply` a second time to resolve it. 

Migration steps:

Modify the `tstate.tf` file to include the appropriate information for the storage account in this environment. Sample below.

```hcl

terraform {
  required_version = "~>1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.45.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.35.0"
    }
  }
   backend "azurerm" {
     resource_group_name  = "prod-va-mp-core-rg"
     storage_account_name = "prodvampsatfstate"
     container_name       = "vatfstatecontainer"
     environment          = "usgovernment"
     key                  = "va-security-core.tfstate"
   }
}
```

Once the `tstate.tf` file is updated, run `terraform init -reconfigure` to update the state file to the remote storage account. when prompted to migrate the state, select `yes`.

once the state is migrated to the remote storage account, you can remove the `terraform.tfstate` terraform.tfstate.backup` file and run `terraform init` to ensure that the state is being pulled from the remote storage account.

## Usage

```hcl
module "core" {
  source = "github.com:Coalfire-CF/ACE-Azure-SecurityCore?ref=v1.0.0"

  subscription_id         = var.subscription_id
  resource_prefix         = local.resource_prefix
  location_abbreviation   = var.location_abbreviation
  location                = var.location
  app_abbreviation        = var.app_abbreviation
  tenant_id               = var.tenant_id
  regional_tags           = var.regional_tags
  global_tags             = var.global_tags
  core_rg_name            = "${local.resource_prefix}-core-rg"
  cidrs_for_remote_access = var.cidrs_for_remote_access
  admin_principal_ids     = var.admin_principal_ids
  enable_diag_logs        = true
  enable_aad_logs         = true
  #diag_law_id             = data.terraform_remote_state.core.outputs.core_la_id
  sub_diag_logs = [
    "Administrative",
    "Security",
    "ServiceHealth",
    "Alert",
    "Recommendation",
    "Policy",
    "Autoscale",
    "ResourceHealth"
  ]
}
```
