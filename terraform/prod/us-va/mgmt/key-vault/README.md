# Key Vault Deployment

This creates the Key Vaults. Permissions are added through the stand alone key vault permissions resource in admin-kv-roles.tf

It takes 15-20 minutes to deploy all the KV's, go grab some coffee.

## Dependencies

- Management VNet
- Application VNet
- VNet Peering

## Code updates

- Add new `{product-kv.tf}` for each hosted product
- Add app subnet ids to the `locals.tf` file

`{product-kv.tf}`
These files should not need updating unless you need to modify Subnet ID's.

`tstate.tf` Update to the appropriate version and storage accounts, see sample

``` hcl
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
    key                  = "va-key-vault.tfstate"
  }
}
```

## Deployment steps

Add or remove vaults as needed to meet client application segmentation patterns or product changes.

`ad-kv.tf` - holds the secrets for ad service accounts

`certs-kv.tf` - holds the certs in boundary encryption

### Key Vault Permissions

Each time a new vault is added a new permissions vault for administrators should be created.

```hcl
resource "azurerm_role_assignment" "trend_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.nessus_kv.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
}
```

### Permissions Scopes

Azure Key Vaults have permissions managed through [Azure Key Vault RBAC Roles.](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli)

Most commonly used permissions in this are

- 'Key Vault Secrets Officer' - Can create and consume secrets
- 'Key Vault Secrets User' - Can consume secrets

You must have a specific Key Vault IAM role assigned to interact with Key vault secrets/certificates/keys. Standard 'Contributor' access to the vault only allows the ability to interact with the vault resource, *not vault contents.*

** A user with 'Owner' or 'User Access Administrator' is the only one that can update the permissions to a Key Vault.

### Deploying

Change directory to the `mgmt/key-vault` folder in the primary region

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the plan is expected.

Run `terraform apply` to deploy.

Update the `remote-data.tf` file to add the region setup state key, see sample.

``` hcl
data "terraform_remote_state" "usgv_key_vaults" {
  backend = "azurerm"

  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix}-core-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = var.az_environment
    key                  = "${var.location_abbreviation}-key-vault.tfstate"
  }
}
```

Run `terraform apply` to connect to the remote data.

## Created Resources

| Resource | Description |
|------|-------------|
| Key Vault | Active Directory |
| Key Vault | Certificates |

## Locals
| Name | Description |
|------|-------------|
| app_subnet_ids | List with all the TM application subnet IDs |

## Next steps

Azure Automation `terraform/prod/us-va/mgmt/azure-automation`
