# Sample README File

Use this file as a starting place and sample for other README files.

## Dependencies

- Security Core
- Region Setup

## Code Updates

`tstate.tf` Update to the appropriate version and storage accounts, see sample

``` hcl
terraform {
  required_version = ">= 1.1.7"
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
    key                  = "va-bastion.tfstate"
  }
}
```

## Deployment Steps

Change directory to the `bastion` folder

Run `terraform init` to download modules and create initial local state file.

Run `terraform plan` to ensure no errors and validate plan is deploying expected resources.

Run `terraform apply` to deploy infrastructure.

Update the `remote-data.tf` file to add the security state key

``` hcl
data "terraform_remote_state" "usgv-bastion" {
  backend = "azurerm"
  config = {
    storage_account_name = "${local.storage_name_prefix}satfstate"
    resource_group_name  = "${local.resource_prefix}-core-rg"
    container_name       = "${var.location_abbreviation}${var.app_abbreviation}tfstatecontainer"
    environment          = "usgovernment"
    key                  = "${var.location_abbreviation}-bastion.tfstate"
  }
}
```

## Created Resources

| Resource | Description |
|------|-------------|
| Windows VM | Windows Bastion 1 |
| Linux VM   | Linux Bastion 2   |
| Windows VM | Windows Bastion 3 |
| Network Security Group | Windows Bastion NSG |
| Network Security Group | Linux Bastion NSG |
| Key Vault Secret | xadm Password |
| Key Vault Secret | Windows Bastion 1 Local Admin Password|
| Key Vault Secret | Windows Bastion 3 Local Admin Password|
| NSG Flow Logs | Windows Bastion NSG Flow Logs|
| NSG Flow Logs | Linux Bastion NSG Flow Logs|
| Public IP Address | Windows Bastion 1 PIP|
| Public IP Address | Linux Bastion 2 PIP|
| Public IP Address | Windows Bastion 3 PIP|
| Network Interface | Windows Bastion 1 NIC|
| Network Interface | Linux Bastion 2 NIC|
| Network Interface | Windows Bastion 3 NIC|


## Next steps

Active Directory Automation (azure/terraform/prod/us-va/mgmt/aa-ad)

## Outputs

| Name | Description |
|------|-------------|
|usgv_ba1_id | ID of Bastion 1 (Windows) |
|usgv_ba2_id | ID of Bastion 2 (Linux) |
|usgv_ba3_id | ID of Bastion 3 (Windows) |

## Additional Information

Currently, access to the Linux Bastion is delegated through admin_ssh_keys. This can be found in the `coalfire-az-linuz-vm` module under the `admin_ssh_key` attribute. 
There are instances where Azure may not take the provided ssh_key and lead to issues accessing the VM. A workaround is as follows:
- Generate an SSH key pair using RSA encryption `ssh-keygen -m PEM -t rsa -b 4096`
- Change the permissions on the key `chmod 400 id_rsa`
- In the Azure Portal, navigate to the VM
- Under `Support + Troubleshooting` navigate to `Reset Password`
- Back in the terminal cat the public key `cat id_rsa.pub` 
- Copy that entire value into the `SSH Public Key` field under `Reset Password`
- For Username, use `xadm`
- One the password on the VM has been reset, SSH to the Linux VM from a terminal window `ssh -i ~/.ssh/id_rsa xadm@<public_ip>`

