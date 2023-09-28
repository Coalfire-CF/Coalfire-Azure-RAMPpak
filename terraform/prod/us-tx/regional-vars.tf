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
    Region      = "USSC"
  }
}

variable "ip_network_mgmt" {
  type    = string
  default = "10.2"
}

variable "ip_network_app" {
  type    = string
  default = "10.3"
}

variable "directory_ip_1" {
  description = "dc1 will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "2.5"
}

variable "directory_ip_2" {
  description = "dc2 will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "2.6"
}

variable "ca_ip_1" {
  description = "ca1 will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "2.7"
}

variable "elasticsearch_ip_1" {
  description = "elasticSearch1 will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "5.5"
}

variable "elasticsearch_ip_2" {
  description = "elasticSearch2 will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "5.6"
}

variable "elasticsearch_ip_3" {
  description = "elasticSearch3 will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "5.7"
}

variable "kibana_ip_1" {
  description = "kibana1 will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "5.8"
}

variable "logstash_ip_1" {
  description = "logstash will join this as network part of IP address and remaining will be fixed IP defined by this variable"
  default     = "5.9"
}
