provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  environment     = "usgovernment"
}

locals {
  resource_prefix_mgmt = "${var.environment}-mgmt-${var.location_abbreviation}"
  resource_prefix_app  = "${var.environment}-app-${var.location_abbreviation}" #<env>-app-va
  resource_prefix_jms  = "${var.environment}-jms-${var.location_abbreviation}" #<env>-jms-va
  resource_prefix_rms  = "${var.environment}-rms-${var.location_abbreviation}" #<env>-rms-va
  resource_prefix_qcr  = "${var.environment}-qcr-${var.location_abbreviation}" #<env>-qcr-va
  resource_prefix_cad  = "${var.environment}-cad-${var.location_abbreviation}" #<env>-cad-va
  vm_name_prefix_mgmt  = replace("${var.environment}-mgmt-${var.location_abbreviation}", "-", "")
  storage_name_prefix  = replace("${var.environment}-mgmt-${var.location_abbreviation}", "-", "")
}

variable "location" {
  default = "usgovvirginia"
}

variable "location_dr" {
  default = "usgovtexas"
}

variable "location_abbreviation" {
  default = "va"
}

variable "regional_tags" {
  type = map(string)
  default = {
    Environment = "Staging"
    Region      = "USGV"
  }
}

variable "environment" {
  type    = string
  default = "stg"
}

#####################
#####################
################# removing this in favor of using the TF cidr tools and the 'mgmt_network_cidr'
# variable "ip_network_mgmt" {
#   type    = string
#   default = "10.0"
# }
#TODO: change all Network Vars - Kourosh
variable "mgmt_network_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "mgmt_se_network_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "mgmt_secured_hub_network_cidr" {
  type    = string
  default = "10.254.252.0/22"
}

variable "appgw_network_cidr" {
  type    = string
  default = "10.254.248.0/22"
}


variable "mark43_app_network_cidr" {
  type    = string
  default = "10.100.0.0/16"
}


variable "mark43_db_network_cidr" {
  type    = string
  default = "10.110.0.0/16"
}


variable "ip_network_mgmt_secondary" {
  type    = string
  default = "10.128"
}

variable "mark43_app_network_secondary" {
  type    = string
  default = "10.200.0.0/16"
}

variable "mark43_db_network_secondary" {
  type    = string
  default = "10.210.0.0/16"
}

#TODO: review and change all vars below as necessary
# AD Variables
variable "domain_name" {
  type    = string
  default = "internal-mark43-staging.us"
}

variable "netbios_name" {
  type    = string
  default = "mark43-gov-stg"
}

variable "dom_disname" {
  type    = string
  default = "DC=internal-mark43-staging,DC=us"
  # Note: single quote is important otherwise the , doesn't' get passed and DSC will fail.
}

variable "dom_disname_cert" {
  type    = string
  default = "DC=internal-mark43-staging, DC=us"
}

variable "domain_join_user_name" {
  type        = string
  default     = "svc-dj"
  description = "AD account used to join nodes to the domain"
}

variable "root_ou_name" {
  default     = "Mark43Government"
  description = "Root OU for Active Directory"
  type        = string
}

variable "top_level_ous" {
  type        = string
  default     = "'All Users','Servers'"
  description = "Top Level OU's in AD: 'All Users','Servers'"
}

variable "user_Ous" {
  type        = string
  default     = "'Administrators','Regular Users','Service Accounts','Security Groups'"
  description = "OUs within 'All Users' OU: 'Administrators','Regular Users','Service Accounts','Security Groups'"
}

variable "env_ous" {
  type        = string
  default     = "'Stage','Test'"
  description = "Env OUs within 'Servers' OU: 'Stage','Test'"
}

variable "location_sub_ous" {
  type        = string
  default     = "'VA','TX'"
  description = "Location OUs within Servers>Environment: 'VA','TX'"
}

variable "server_sub_ous" {
  type        = string
  default     = "'Windows','Linux'"
  description = "Server OUs within Servers>Environment>Location: 'Windows','Linux'"
}

variable "ad_groups" {
  type        = string
  default     = "'LinuxAdmins','WindowsAdmins','VPNUsers','VPNAdmins','WebServerCertPublishers','JiraUsers','JiraAdmins','AquaUsers','GitHubUsers','GitHubAdmins'"
  description = "List of initial groups 'LinuxAdmins', 'WindowsAdmins','VPNUsers', 'VPNAdmins', 'WebServerCertPublishers', 'JiraUsers', 'JiraAdmins', 'AquaUsers', 'GitHubUsers','GitHubAdmins'"
}

variable "vnet_cidrs" {
  type        = string
  default     = "10.0.0.0/16,10.1.0.0/22,10.254.0.0/16,10.100.0.0/16,10.110.0.0/16" #Primary mgmt/app & DR Mgmt/app
  description = "Comma delimited blocks where vm's can reside: 10.0.0.0/16,10.1.0.0/22,10.254.0.0/16,10.100.0.0/16,10.110.0.0/16"
}

variable "ca_server_fqdn" {
  description = "CA Server FQDN utilized"
  type        = string
  default     = "stgmgmtvaca"
}

variable "nb_ip_1" {
  description = "nessus/burp will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "2.9"
}

variable "linux_admins_ad_group" {
  default     = "LinuxAdmins"
  description = "Active Directory group to grant linux admin privileges"
  type        = string
}

variable "windows_admins_ad_group" {
  default     = "WindowsAdmins"
  description = "Active Directory group to grant windows admin privileges"
  type        = string
}

# CA Variables
# variable "ca_com_name" {
#   default     = "Launchpad Gov Root CA"
#   description = "The common name for the root CA"
#   type        = string
# }

variable "root_ca_pub_cert" {
  default     = "mark43-gov-stgvampca-CA"
  description = "Mark43 Root CA public certificate common name"
  type        = string
}

variable "aqua_cert" {
  default     = "aqua.internal-mark43-staging.us"
  description = "Aqua certificate Subject"
  type        = string
}

variable "github_cert" {
  default     = "github.internal-mark43-staging.us"
  description = "GitHub certificate Subject"
  type        = string
}

variable "jira_cert" {
  default     = "jira.internal-mark43-staging.us"
  description = "Jira certificate Subject"
  type        = string
}

variable "nessus_cert" {
  default     = "nessus.internal-mark43-staging.us"
  description = "Nessus certificate Subject"
  type        = string
}


