provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

variable "location" {
  default = "southcentralus"
}

variable "location_abbreviation" {
  default = "ussc"
}

variable "regional_tags" {
  type = map(string)
  default = {
    Environment = "Diaster Recovery"
    Application = "azurelaunchpad+"
    Region      = "ussc"
  }
}

locals {
  environment = lookup(var.workspace_to_environment, terraform.workspace, "Production")
}


variable "workspace_to_environment" {
  type = map(string)

  default = {
    default = "mgmt"
  }
}

# used in all-SG
variable "cidrs_for_remote_access" {
  type        = list(any)
  description = "List of IPv4 CIDR ranges to access all admins remote access"

  # Coalfire VPN  "209.236.109.246/32"
  # Reston Office "63.235.52.58/32",
  # Douglas "207.179.214.235/32,"
  # Andy "73.128.78.126/32",

  default = [
    "209.236.109.246/32",
    "63.235.52.58/32",
    "207.179.214.235/32",
    "73.128.78.126/32",
  ]
}

variable "admin_principal_ids" {
  type        = set(string)
  description = "List of principal ID's for all admins"

  # Andy "1d773db2-15ad-44f1-9622-1fbc0b2d18bb",
  # Douglas "571df810-48f7-40c8-b91b-a6edfb904e50"

  default = [
    "1d773db2-15ad-44f1-9622-1fbc0b2d18bb",
    "571df810-48f7-40c8-b91b-a6edfb904e50",
  ]
}

variable "ip_network_mgmt" {
  type    = string
  default = "10.2"
}

variable "ip_network_app" {
  type    = string
  default = "10.3"
}

variable "create_monitor" {
  description = "Whether or not to create Azure Monitor resources"
  type        = bool
  default     = true
}

variable "vm_admin_username" {
  type        = string
  description = "Local User Name for Virtual Machines"
  default     = "xadm"

}

variable "directory_ip_1" {
  description = "variable ip_network_mgmt will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "2.5"
}

variable "directory_ip_2" {
  description = "variable ip_network_mgmt will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "2.6"
}

variable "ca_ip_1" {
  description = "variable ip_network_mgmt will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "2.7"
}

variable "elasticsearch_ip_1" {
  description = "variable ip_network_mgmt will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "5.5"
}

variable "elasticsearch_ip_2" {
  description = "variable ip_network_mgmt will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "5.6"
}

variable "elasticsearch_ip_3" {
  description = "variable ip_network_mgmt will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "5.7"
}

variable "kibana_ip_1" {
  description = "variable ip_network_mgmt will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "5.8"
}

variable "logstash_ip_1" {
  description = "variable ip_network_mgmt will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "5.9"
}

variable "nb_ip_1" {
  description = "variable ip_network_mgmt will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "4.5"
}

variable "sql_ip_1" {
  description = "variable ip_network_app will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "3.6"
}

variable "sql_ip_2" {
  description = "variable ip_network_app will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "3.7"
}

variable "sql_ip_3" {
  description = "variable ip_network_app will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "3.6"
}

variable "sql_port_number" {
  description = "Port number the SQL server will be configured to listen on"
  default     = 1433
}


variable "linux_admins_ad_group" {
  default     = "linuxadmins"
  description = "Active Directory group to grant linux admin privs"
  type        = string
}

# CA Variables
variable "ca_com_name" {
  default     = "azurelaunchpad+ Gov Root CA"
  description = "The common name for the root CA"
  type        = string
}

variable "root_ca_pub_cert" {
  default     = "root_ca_pub.pem"
  description = "Root CA public certificate file name"
  type        = string
}

variable "dsm_cert" {
  default     = "dsm_cert"
  description = "Trend Micro DSM certificate"
  type        = string
}

variable "tower_cert" {
  default     = "tower_cert"
  description = "Ansible Tower certificate"
  type        = string
}
