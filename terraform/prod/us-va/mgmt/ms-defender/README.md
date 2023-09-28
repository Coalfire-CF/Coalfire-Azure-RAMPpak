# Microsoft Defender Deployment

This configures Microsoft Defender for Cloud to the given subscription(s)

## Dependencies

- Security Core

## Resource List

- Security Center
- Security Center subscription plans: KubernetesService, SqlServers, SqlServerVirtualMachines, StorageAccounts, VirtualMachines, Arm, OpenSourceRelationalDatabases, Containers and Dns

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
    var.az_environment
    key                  = "va-mgmt-defender.tfstate"
  }
}
```

## Deployment steps

Change directory to the `mgmt/ms-defender` folder in the primary region

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the plan is expected.

Run `terraform apply` to deploy.

Update the `remote-data.tf` file to add the policies state key

Rerun `terraform apply` to update all changes

## Product Limitations

- File integrity monitoring (FIM) is only available from Defender for Cloud's pages in the Azure portal. There is currently no REST API for working with FIM. To **enable** it, follow this [document](https://docs.microsoft.com/en-us/azure/defender-for-cloud/file-integrity-monitoring-overview?wt.mc_id=defenderforcloud_inproduct_portal_recoremediation).
- Microsoft Defender for Cosmos DB is not currently available in Azure government and sovereign cloud regions. For more information, refer to the [Azure Docs](https://docs.microsoft.com/en-us/azure/cosmos-db/sql/defender-for-cosmos-db?tabs=azure-portal).

## Additional information

Defender for Cloud is a tool for security posture management and threat protection. It strengthens the security posture of your cloud resources, and with its integrated Microsoft Defender plans, Defender for Cloud protects workloads running in Azure, hybrid, and other cloud platforms.

For more information regarding defender, refer to the [Azure docs](https://docs.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction).

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|

## Outputs

| Name | Description |
|------|-------------|
