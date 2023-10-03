# LOCALS
locals {
  resource_prefix     = "${var.app_abbreviation}-${var.environment}-${var.location_abbreviation}-${var.function}"
  vm_name_prefix      = replace(local.resource_prefix, "-", "")
  storage_name_prefix = replace(local.resource_prefix, "-", "")
  global_local_tags = {
    Deployed_FromDir = "${element(split("/", path.cwd), length(split("/", path.cwd)) - 2)}/${element(split("/", path.cwd), length(split("/", path.cwd)) - 1)}"
  }
}

# VARIABLES
variable "az_environment" {
  description = "usgovernment or commercial"
  type        = string
  default     = "usgovernment"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID for the Azure Subscription"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID for the Azure AD Tenant"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "app_subscription_ids" {
  type        = map(any)
  description = "Application Subscription ID's if applicable"
  default = {
    app1 = "00000000-0000-0000-0000-000000000000"
    app2 = "00000000-0000-0000-0000-000000000000"
  }
}

variable "app_abbreviation" {
  description = "A abbreviation that should be attached to the names of resources.  Must be 1-3 chars."
  type        = string
  default     = "app" # Application
}

variable "function" {
  type        = string
  description = "Function that describes the resources being created"
  default     = "mp" # Management Plane
}

variable "global_tags" {
  type = map(string)
  default = {
    Managed_By = "Terraform"
  }
}

variable "cidrs_for_remote_access" {
  type        = list(any)
  description = "List of IPv4 CIDR ranges to access all admins remote access"

  # Company VPN  "127.0.0.1/32"
  # Engineer1 "127.0.0.2/32"
  # Engineer2 "127.0.0.3/32"

  default = [
    "127.0.0.1/32",
    "127.0.0.2/32",
    "127.0.0.3/32"
  ]
}

variable "ip_for_remote_access" {
  type        = list(any)
  description = "This is the same as 'cidrs_for_remote_access' but without the /32 on each of the files. The 'ip_rules' in the storage account will not accept a '/32' address"

  default = [
    "127.0.0.1",
    "127.0.0.2",
    "127.0.0.3"
  ]
}

variable "admin_principal_ids" {
  type        = set(string)
  description = "List of principal ID's for all admins"

  # Subscription: FedRAMPSub
  # Engineer1 "00000000-0000-0000-0000-000000000000"

  default = [
    "00000000-0000-0000-0000-000000000000"
  ]
}

variable "vm_admin_username" {
  type        = string
  description = "Local User Name for Virtual Machines"
  default     = "xadm"
}

variable "azure_cloud" {
  type        = string
  description = "Azure Cloud (AzureCloud - AzureUSGovernment)"
  default     = "AzureUSGovernment"
}
