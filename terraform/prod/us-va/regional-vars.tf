provider "azurerm" {
  features {}

  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  environment                = var.az_environment
  skip_provider_registration = true
}

variable "location" {
  type        = string
  description = "Location for the resources"
  default     = "usgovvirginia"
}

variable "location_dr" {
  type        = string
  description = "Location for the DR resources"
  default     = "usgovtexas"
}

variable "location_abbreviation" {
  default = "va"
}

variable "regional_tags" {
  type        = map(string)
  description = "Regional tags to be applied to resources"
  default = {
    Environment = "Production"
    Region      = "USGV"
  }
}

variable "environment" {
  type        = string
  description = "Environment for the resources"
  default     = "prod"
}

variable "mgmt_network_cidr" {
  type        = string
  description = "CIDR for the management network"
  default     = "10.10.0.0/16"
}

variable "app_network_cidr" {
  type        = string
  description = "CIDR for the application networks if applicable"
  default     = "10.20.0.0/16"
}

variable "availability_zone_1" {
  type        = list(number)
  description = "Variable to specify Availability Zone 1"
  default     = [1]
  validation {
    condition     = alltrue([for zone in var.availability_zone_1 : zone == 1])
    error_message = "Availability Zone 1 must be 1."
  }
}

variable "availability_zone_2" {
  type        = list(number)
  description = "Variable to specify Availability Zone 2"
  default     = [2]
  validation {
    condition     = alltrue([for zone in var.availability_zone_2 : zone == 2])
    error_message = "Availability Zone 1 must be 2."
  }
}

variable "availability_zone_3" {
  type        = list(number)
  description = "Variable to specify Availability Zone 3"
  default     = [3]
  validation {
    condition     = alltrue([for zone in var.availability_zone_3 : zone == 3])
    error_message = "Availability Zone 1 must be 3."
  }
}

#########
variable "fw_virtual_network_subnet_ids" {
  type        = list(string)
  description = "List of subnet ids for the firewall"
  default     = []
}

