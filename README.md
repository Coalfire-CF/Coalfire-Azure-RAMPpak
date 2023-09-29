![Coalfire](coalfire_logo.png)

# Coalfire-Azure-RAMPpak

Coalfire created reference architecture for FedRAMP Azure builds. This repository is used as a parent directory to deploy `Coalfire-CF/terraform-azurerm-<service>` modules.

Learn more at [Coalfire OpenSource](https://coalfire.com/opensource).

## Dependencies

- Azure Commercial or Government Subscription
- Azure Tenant Provisioning 
- [az cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) is installed
- User with, at minimum, `contributor` subscription access
- Terraform is installed and in PATH.

## Repository Structure

| Directory | Purpose |
| --------- | ------- |
| `shellscripts/` | Deployment and VM Extension scripts |
| `terraform/prod/us-tx/` | Disaster Recovery region terraform files |
| `terraform/prod/us-va/` | Primary region terraform files |
| `terraform/prod/global-vars.tf` | Global variables |
| `terraform/prod/us-va/app/` | Application plane terraform files |
| `terraform/prod/us-va/mgmt/` | Management plane terraform files |
| `terraform/prod/us-va/region-setup/` | Management plane `region-setup` terraform files |
| `terraform/prod/us-va/mgmt/security-core` | Management plane `security-core` terraform files |
| `terraform/prod/us-va/regional-vars.tf` | Regional variables |
| `terraform/prod/us-va/remote-data.tf` | Remote Data from state files. Uncomment as more infrastructure is deployed |

## Code Updates

1. Update `terraform/prod/global-vars.tf` variables
2. Update `terraform/prod/us-va/regional-vars.tf` variables, if applicable

## Deployment 

1. Login to the azure cli, `az login`. You may have to change the cloud if you receive an error. `az cloud set --name AzureUSGovernment`
2. Navigate to `terraform/prod/us-va/security-core` and run `terraform init` and `terraform plan`. If everything looks good run `terraform apply`.
3. Navigate to `terraform/prod/us-va/region-setup` and run `terraform init` and `terraform plan`. If everything looks good run `terraform apply`.
4. Deploy `mgmt` and `app` resources in a similar fashion. Order of deployment is below.

## Deployment Order of Operations

1. Azure Tenant Provisioning
2. Security Core (terraform/prod/us-va/security-core)
3. Region Setup (terraform/prod/us-va/region-setup)
4. Management VNet (terraform/prod/us-va/mgmt/mgmt-network)
5. Application VNet (terraform/prod/us-va/app/app-network)
6. Management/Application VNet Peering (terraform/prod/us-va/mgmt/vnet-peering)
7. Key Vaults (terraform/prod/us-va/mgmt/key-vault)
8. Azure Automation (terraform/prod/us-va/mgmt/azure-automation)
9. Bastion (terraform/prod/us-va/mgmt/bastion)
10. Backup (terraform/prod/us-va/mgmt/backup)
11. Sentinel (terraform/prod/us-va/mgmt/sentinel)
12. Other tooling/Application Plane

## Deployment Configurations

Each module, e.g. `region-setup`, has a README file that provides deployment steps, dependencies, and other notes on each component in the environment.

## Modifications when new Admins are added

- Add their PIP or use the Coalfire VPN to access and deploy resources, otherwise the user cannot access Key Vaults, storage account with the state files or the bastion hosts.

- Re-run `terraform apply` on the bastion folder to add the new PIP to the bastion NSG.

- Re-run `terraform apply` on the key-vault, security-core, and region-setup folder to add the new admin's GUID to the Admin roles

## Setting Cloud Provider

For Azure Government cloud

`az cloud set --name AzureUSGovernment`

By default, AZCLI is configured for commercial cloud. If you need to switch back from another selection:

`az cloud set --name AzureCloud`

Log into the Azure Tenant with your Azure Active Directory (AAD) credentials.

`az login`

Follow the instructions in the terminal to log in via web portal with your credentials.

Upon a successful login you should see output similar to this.

```hcl
[
  {
    "cloudName": "AzureCloud",
    "id": "REDACTED",
    "isDefault": true,
    "name": "Azure subscription 1",
    "state": "Enabled",
    "tenantId": "REDACTED",
    "user": {
      "name": "engineer1@example.com",
      "type": "user"
    }
  }
]
```

Set a specific subscription

`az account set --subscription {GUID}`

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Contributing

[Relative or absolute link to contributing.md](CONTRIBUTING.md)


## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)


## Coalfire Pages

[Absolute link to any relevant Coalfire Pages](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.
