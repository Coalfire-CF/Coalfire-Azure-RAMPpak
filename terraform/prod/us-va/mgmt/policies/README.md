# Policies Deployment

This assigns Azure policies to the given subscription(s)

## Dependencies

- Backup

## Code updates

`tstate.tf` Update to the appropriate version and storage accounts, see sample

```hcl
terraform {
  required_version = "1.3.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.1.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "v1-prod-va-mp-core-rg"
    storage_account_name = "v1prodvampsatfstate"
    container_name       = "vav1tfstatecontainer"
    var.az_environment
    key                  = "va-mgmt-policies.tfstate"
  }
}
```

## Deployment steps

Change directory to the `mgmt/policies` folder in the primary region

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the plan is expected.

Run `terraform apply` to deploy.

Update the `remote-data.tf` file to add the policies state key

Rerun `terraform apply` to update all changes

## Created Resources

| Resource | Description |
|------|-------------|
| FedRamp Moderate | Assigns the FedRamp moderate initative |
| AKS Policies | Assigns Kubernetes cluster pod security baseline standard policies for Linux-based workloads |
| Backup Policy | Assigns backup policy which backups virtual machines with a given tag to a recovery services vault |
| Built-In Policies | Assigns built-in policies not covered under the [FedRamp Moderate](https://docs.microsoft.com/en-us/azure/governance/policy/samples/fedramp-moderate) built-in initiative |
| Custom Policies | Assigns custom policies not covered under the [FedRamp Moderate](https://docs.microsoft.com/en-us/azure/governance/policy/samples/fedramp-moderate) built-in initiative |

## Azure Policy

This repo uses [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview). The Azure backup policy is divided in 2 parts, parameters and policy rule. Parameters are variables used in the policy rule. The policy rule consists of If and Then blocks. In the If block, you define one or more conditions that specify when the policy is enforced.

For more information regarding policy structure, refer to the [Azure docs](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure).

## Additional Information

- The deployment takes 40-60 minutes to deploy since each policy assignment takes 1-2 min to complete.
- Each subscription requires its own `azurerm` provider block to assign custom policies
- Auto remediation for "deployIfNotexist" as well as "modify" policies ist enabled by default, however just for resources created after policy enablement. All resources that you have created before, you can remediate through the Azure Policy Option "Remediate" (within the Azure Portal -> Policy). Hope that helps.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|

## Outputs

| Name | Description |
|------|-------------|
