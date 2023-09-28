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
    Application = "Launchpad"
    Region      = "ussc"
  }
}


variable "admin_principal_ids" {
  type        = set(string)
  description = "List of principal ID's for all admins"

  # Douglas "GUID"

  default = [
    "GUID"
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
