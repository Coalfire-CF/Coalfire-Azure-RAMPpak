# Key Vault Deployment

This creates the Key Vaults. Permissions are added through the stand alone key vault permissions resource in admin-kv-roles.tf

It takes 15-20 minutes to deploy all the KV's, go grab some coffee.

## Dependencies

- Management VNet
- Application VNet
- VNet Peering

## Code updates

`{product-kv.tf}`
These files should not need updating unless you need to modify Subnet ID's

`tstate.tf` Update to the appropriate version and storage accounts, see sample

``` hcl
terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.45.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "v1-prod-va-mp-core-rg"
    storage_account_name = "v1prodvampsatfstate"
    container_name       = "vav1tfstatecontainer"
    var.az_environment
    key                  = "va-keyvault.tfstate"
  }
}
```

## Deployment steps

Add or remove vaults as needed to meet client application segmentation patterns or product changes.

ad-kv.tf - holds the secrets for ad service accounts

domain-join-kv.tf - holds the domain join account credential

app-kv.tf - holds application plane secrets

trend-kv.tf - holds the trend micro secrets

tower.tf - holds the ansible tower secrets

### Key Vault Permissions

Each time a new vault is added a new permissions vault for administrators should be created.

```hcl
resource "azurerm_role_assignment" "trend_kv_secrets_officer" {
  for_each             = var.admin_principal_ids
  scope                = module.trend_kv.key_vault_id
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

Change directory to the `mgmt/mgmt-network` folder in the primary region

Run `terraform init` to initialize modules and remote state.

Run `terraform plan` and evaluate the plan is expected.

Run `terraform apply` to deploy.

Update the `remote-data.tf` file to add the region setup state key, see sample.

``` hcl
data "terraform_remote_state" "usgv_keyvault" {
  backend = "azurerm"

  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix}-core-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    var.az_environment
    key                  = "${var.location_abbreviation}-keyvault.tfstate"
  }
}
```

Run `terraform apply` to connect to the remote data.

## Created Resources

| Resource | Description |
|------|-------------|
| Key Vault | Active Directory |
| Key Vault | Certificates |
| Key Vault | Domain Join |
| Key Vault | TrendMicro |
| Key Vault | Nessus |
| Key Vault | Burp |
| Key Vault | Ansible Tower |
| Key Vault | Jira |
| Key Vault | Jenkins |

## Locals
| Name | Description |
|------|-------------|
| app_subnet_ids | List with all the TM application subnet IDs |

## Next steps

Create Packer Images

## Outputs

| Name | Description |
|------|-------------|
| usgv_ad_kv_uri | URI of the Active Directory Key Vault |
| usgv_ad_kv_name | Name of the Active Directory Key Vault |
| usgv_ad_kv_id | ID of the Active Directory Key Vault |
| usgv_dj_kv_uri | URI of the domain join Key Vault |
| usgv_dj_kv_name | Name of the domain join Key Vault |
| usgv_dj_kv_id | ID of the domain joinKey Vault |
| usgv_app_kv_uri | URI of the application plane Key Vault |
| usgv_app_kv_name | Name of the application plane Key Vault |
| usgv_app_kv_id | ID of the application plane Key Vault |
| usgv_certs_kv_uri | URI of the Certificates Key Vault |
| usgv_certs_kv_name | Name of the Certificates Key Vault |
| usgv_certs_kv_id | ID of the Certificates Key Vault |
| usgv_tower_kv_uri | URI of the Ansible Tower Key Vault |
| usgv_tower_kv_name | Name of the Ansible Tower Key Vault |
| usgv_tower_kv_id | ID of the Ansible Tower Key Vault |
| usgv_trend_kv_uri | URI of the Trend Micro DSM Key Vault |
| usgv_trend_kv_name | Name of the Trend Micro DSM Key Vault |
| usgv_trend_kv_id | ID of the Trend Micro DSM Key Vault |
| usgv_jenkins_kv_uri | URI of the Jenkins Key Vault |
| usgv_jenkins_kv_name | Name of the Jenkins Key Vault |
| usgv_jenkins_kv_id | ID of the Jenkins Key Vault |
